
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

    public async Task<PagamentoDetalheDto> GetPagamentoDetalheDto(string userId, CancellationToken cancellationToken = default)
    {
      var result = await _dbConnection.QueryAsync<dynamic>(
          @"
            SELECT
	            v.id AS id,
	            v.status AS status,
	            v.datahora AS datahora,
	            v.total AS total,	
              c.user_id AS compradoruserid,
              c.nome AS compradornome,
	            c.foto_url AS compradorfotourl
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id                      
            WHERE v.status=0 and c.user_id=@id
          ", new { id = userId }
      );

      if (result.AsList().Count == 0)
      {
        result = await _dbConnection.QueryAsync<dynamic>(
          @"
            SELECT
                c.user_id AS compradoruserid,
                c.nome AS compradornome,
	            c.foto_url AS compradorfotourl
            FROM compradores c
            WHERE c.user_id=@id
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