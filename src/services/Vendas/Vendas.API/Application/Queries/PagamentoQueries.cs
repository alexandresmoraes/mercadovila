
using Common.WebAPI.Results;
using Dapper;
using System.Data;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Queries
{
  public class PagamentoQueries : IPagamentosQueries
  {
    private readonly IDbConnection _dbConnection;

    public PagamentoQueries(IDbConnection dbConnection)
    {
      _dbConnection = dbConnection;
    }

    public async Task<PagamentoDetalheDto> GetPagamentoDetalhe(string userId, CancellationToken cancellationToken = default)
    {
      var result = await _dbConnection.QueryAsync<dynamic>(
          @"
            SELECT
	            v.id AS id,
	            v.status AS status,
	            v.datahora AS datahora,
	            v.total AS total,	
              c.id AS compradoruserid,
              c.nome AS compradornome,
	            c.foto_url AS compradorfotourl
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id                      
            WHERE v.status=0 and c.id=@id
          ", new { id = userId }
      );

      if (result.AsList().Count == 0)
      {
        result = await _dbConnection.QueryAsync<dynamic>(
          @"
            SELECT
                c.id AS compradoruserid,
                c.nome AS compradornome,
	            c.foto_url AS compradorfotourl
            FROM compradores c
            WHERE c.id=@id
          ", new { id = userId }
        );

        if (result.AsList().Count == 0)
        {
          return new PagamentoDetalheDto
          {
            CompradorUserId = userId,
          };
        }

        return new PagamentoDetalheDto
        {
          CompradorUserId = userId,
          CompradorNome = result.AsList()[0].compradornome,
          CompradorFotoUrl = result.AsList()[0].compradorfotourl,
        };
      }

      return MapPagamentoDetalhe(result);
    }

    public async Task<PagedResult<PagamentosDto>> GetPagamentos(PagamentosQuery query, CancellationToken cancellationToken = default)
    {
      var pagamentos = new List<PagamentosDto>();

      var sql = @"
                  SELECT
	                  p.id AS id,
                    p.tipo AS tipo,
	                  p.status AS status,
	                  p.datahora AS datahora,
	                  p.valor AS valor,	
                    c.id AS compradoruserid,
                    c.nome AS compradornome,
	                  c.foto_url AS compradorfotourl,
                    c.email AS compradoremail,
                    count(*) over() AS count
                  FROM pagamentos p
                  LEFT JOIN compradores c ON c.id = p.comprador_id";

      var offset = (query.page - 1) * query.limit;

      if (!string.IsNullOrWhiteSpace(query.username))
      {
        sql += " WHERE c.nome ilike @username ";
      }

      sql += @" 
                ORDER BY p.datahora DESC 
                LIMIT @limit OFFSET @offset;
      ";

      var result = await _dbConnection.QueryAsync<dynamic>(sql, new
      {
        username = $"%{query.username}%",
        query.limit,
        offset,
      });

      foreach (var row in result)
      {
        pagamentos.Add(new PagamentosDto
        {
          PagamentoId = row.id,
          PagamentoDataHora = row.datahora,
          PagamentoTipo = (EnumTipoPagamento)row.tipo,
          PagamentoStatus = (EnumStatusPagamento)row.status,
          CompradorNome = row.compradornome,
          CompradorFotoUrl = row.compradorfotourl,
          CompradorUserId = row.compradoruserid,
          CompradorEmail = row.compradoremail,
          PagamentoValor = row.valor,
        });
      }

      long total = result.FirstOrDefault()?.count ?? 0;

      return new PagedResult<PagamentosDto>(offset, query.limit, total, pagamentos);
    }

    private PagamentoDetalheDto MapPagamentoDetalhe(dynamic result)
    {
      var vendas = new List<PagamentoDetalheVendaDto>();

      foreach (dynamic item in result)
      {
        var venda = new PagamentoDetalheVendaDto
        {
          VendaId = item.id,
          Status = (EnumVendaStatus)item.status,
          DataHora = item.datahora,
          Total = item.total,
        };

        vendas.Add(venda);
      }

      return new PagamentoDetalheDto
      {
        CompradorUserId = result[0].compradoruserid,
        CompradorNome = result[0].compradornome,
        CompradorFotoUrl = result[0].compradorfotourl,
        Vendas = vendas,
        Total = vendas.Sum(_ => _.Total),
      };
    }
  }
}