using Common.WebAPI.Results;
using Dapper;
using System.Data;
using Vendas.Domain.Aggregates;

namespace Vendas.API.Application.Queries
{
  public class VendasQueries : IVendasQueries
  {
    private readonly IDbConnection _dbConnection;

    public VendasQueries(IDbConnection dbConnection)
    {
      _dbConnection = dbConnection;
    }

    public async Task<VendaDetalheDto?> GetVendaAsync(long vendaId, CancellationToken cancellationToken = default)
    {
      var result = await _dbConnection.QueryAsync<dynamic>(
          @"
            SELECT
	            v.id AS id,
	            v.status AS status,
	            v.datahora AS datahora,
	            v.total AS total,
	            vi.produto_id AS itemprodutoid,
	            vi.nome AS itemnome, 
              vi.descricao AS itemdescricao,
	            vi.image_url AS itemimageurl,
	            vi.preco AS itempreco,
	            vi.quantidade AS itemquantidade,
	            vi.unidade_medida AS itemunidademedida,
              c.user_id AS compradoruserid
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id
            LEFT JOIN venda_itens vi ON v.id = vi.venda_id            
            WHERE v.id=@id
          ", new { id = vendaId }
      );

      if (result.AsList().Count == 0)
        return null;

      return MapVendaDetalhe(result);
    }

    public async Task<PagedResult<VendaDto>> GetVendasAsync(VendaQuery vendaQuery, CancellationToken cancellationToken = default)
    {
      var vendasDictionary = new Dictionary<long, VendaDto>();

      var sql = @"
            SELECT
	            v.id AS id,
	            v.status AS status,
	            v.datahora AS datahora,
	            v.total AS total,
	            vi.produto_id AS itemprodutoid,
	            vi.nome AS itemnome, 
	            vi.image_url AS itemimageurl,
	            vi.preco AS itempreco,
	            vi.quantidade AS itemquantidade,
	            vi.unidade_medida AS itemunidademedida,
	            c.nome AS compradornome,
	            c.foto_url AS compradorfotourl,
              count(*) over() AS count
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id
            LEFT JOIN venda_itens vi ON v.id = vi.venda_id            
      ";

      if (vendaQuery.dataInicial.HasValue && vendaQuery.dataFinal.HasValue)
      {
        sql += " WHERE v.datahora BETWEEN @dataInicial AND @datafinal";
      }
      else if (vendaQuery.dataInicial.HasValue)
      {
        sql += " WHERE v.datahora > @dataInicial";
      }
      else if (vendaQuery.dataFinal.HasValue)
      {
        sql += " WHERE v.datahora < @datafinal";
      }

      var start = (vendaQuery.page - 1) * vendaQuery.limit;
      sql += @" 
                ORDER BY v.datahora DESC 
                LIMIT @limit OFFSET @offset;
      ";

      var result = await _dbConnection.QueryAsync<dynamic>(sql, new
      {
        dataInicial = vendaQuery.dataInicial,
        datafinal = vendaQuery.dataFinal,
        limit = vendaQuery.limit,
        offset = start
      });

      foreach (var row in result)
      {
        var vendaId = row.id;
        if (!vendasDictionary.TryGetValue(vendaId, out VendaDto venda))
        {
          venda = new VendaDto
          {
            Id = vendaId,
            Status = (EnumVendaStatus)row.status,
            DataHora = row.datahora,
            Total = row.total,
            CompradorNome = row.compradornome,
            CompradorFotoUrl = row.compradorfotourl,
          };
          vendasDictionary.Add(vendaId, venda);
        }

        var vendaItem = new VendaItemto
        {
          ProdutoId = row.itemprodutoid,
          Nome = row.itemnome,
          ImageUrl = row.itemimageurl,
          Preco = row.itempreco,
          Quantidade = row.itemquantidade,
          UnidadeMedida = row.itemunidademedida
        };
        venda.Itens.Add(vendaItem);
      }

      long total = result.FirstOrDefault()?.count ?? 0;

      return new PagedResult<VendaDto>(start, vendaQuery.limit, total, vendasDictionary.Values.ToList());
    }

    public async Task<PagedResult<VendaDto>> GetMinhasComprasAsync(VendaQuery vendaQuery, string userId, CancellationToken cancellationToken = default)
    {
      var vendasDictionary = new Dictionary<long, VendaDto>();

      var sql = @"
            SELECT
	            v.id AS id,
	            v.status AS status,
	            v.datahora AS datahora,
	            v.total AS total,
	            vi.produto_id AS itemprodutoid,
	            vi.nome AS itemnome, 
	            vi.image_url AS itemimageurl,
	            vi.preco AS itempreco,
	            vi.quantidade AS itemquantidade,
	            vi.unidade_medida AS itemunidademedida,
	            c.nome AS compradornome,
	            c.foto_url AS compradorfotourl,
              count(*) over() AS count
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id
            LEFT JOIN venda_itens vi ON v.id = vi.venda_id   
            WHERE c.user_id=@userid
      ";

      if (vendaQuery.dataInicial.HasValue && vendaQuery.dataFinal.HasValue)
      {
        sql += " AND (v.datahora BETWEEN @dataInicial AND @datafinal)";
      }
      else if (vendaQuery.dataInicial.HasValue)
      {
        sql += " AND v.datahora > @dataInicial";
      }
      else if (vendaQuery.dataFinal.HasValue)
      {
        sql += " AND v.datahora < @datafinal";
      }

      var start = (vendaQuery.page - 1) * vendaQuery.limit;
      sql += @" 
                ORDER BY v.datahora DESC 
                LIMIT @limit OFFSET @offset;
      ";

      var result = await _dbConnection.QueryAsync<dynamic>(sql, new
      {
        userid = userId,
        dataInicial = vendaQuery.dataInicial,
        datafinal = vendaQuery.dataFinal,
        vendaQuery.limit,
        offset = start
      });

      foreach (var row in result)
      {
        var vendaId = row.id;
        if (!vendasDictionary.TryGetValue(vendaId, out VendaDto venda))
        {
          venda = new VendaDto
          {
            Id = vendaId,
            Status = (EnumVendaStatus)row.status,
            DataHora = row.datahora,
            Total = row.total,
            CompradorNome = row.compradornome,
            CompradorFotoUrl = row.compradorfotourl,
          };
          vendasDictionary.Add(vendaId, venda);
        }

        var vendaItem = new VendaItemto
        {
          ProdutoId = row.itemprodutoid,
          Nome = row.itemnome,
          ImageUrl = row.itemimageurl,
          Preco = row.itempreco,
          Quantidade = row.itemquantidade,
          UnidadeMedida = row.itemunidademedida
        };
        venda.Itens.Add(vendaItem);
      }

      long total = result.FirstOrDefault()?.count ?? 0;

      return new PagedResult<VendaDto>(start, vendaQuery.limit, total, vendasDictionary.Values.ToList());
    }

    private VendaDetalheDto MapVendaDetalhe(dynamic result)
    {
      var venda = new VendaDetalheDto
      {
        Id = result[0].id,
        Status = (EnumVendaStatus)result[0].status,
        DataHora = result[0].datahora,
        Total = result[0].total,
        CompradorUserId = result[0].compradoruserid,
      };

      foreach (dynamic item in result)
      {
        var vendaItem = new VendaItemDetalheDto
        {
          ProdutoId = item.itemprodutoid,
          Nome = item.itemnome,
          Descricao = item.itemdescricao,
          ImageUrl = item.itemimageurl,
          Preco = item.itempreco,
          Quantidade = item.itemquantidade,
          UnidadeMedida = item.itemunidademedida,
        };

        venda.Itens.Add(vendaItem);
      }

      return venda;
    }
  }
}
