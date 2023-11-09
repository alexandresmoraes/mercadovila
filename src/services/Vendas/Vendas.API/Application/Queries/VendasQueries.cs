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

    public async Task<VendaDetalhe?> GetVendaAsync(long vendaId, CancellationToken cancellationToken = default)
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
	            vi.image_url AS itemimageurl,
	            vi.preco AS itempreco,
	            vi.quantidade AS itemquantidade,
	            vi.unidade_medida AS itemunidademedida
            FROM vendas v
            LEFT JOIN venda_itens vi ON v.id = vi.venda_id
            WHERE v.id=@id
          ", new { id = vendaId }
      );

      if (result.AsList().Count == 0)
        return null;

      return MapVendaDetalhe(result);
    }

    public async Task<IEnumerable<Venda>> GetVendasAsync(VendaQuery vendaQuery, CancellationToken cancellationToken = default)
    {
      var vendasDictionary = new Dictionary<long, Venda>();

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
	            c.foto_url AS compradorfotourl
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id
            LEFT JOIN venda_itens vi ON v.id = vi.venda_id            
      ";

      if (vendaQuery.dataInicio.HasValue && vendaQuery.dataFinal.HasValue)
      {
        sql += " WHERE v.datahora BETWEEN @datainicio AND @datafinal";
      }
      else if (vendaQuery.dataInicio.HasValue)
      {
        sql += " WHERE v.datahora > @datainicio";
      }
      else if (vendaQuery.dataFinal.HasValue)
      {
        sql += " WHERE v.datahora < @datafinal";
      }

      var result = await _dbConnection.QueryAsync<dynamic>(sql, new
      {
        datainicio = vendaQuery.dataInicio,
        datafinal = vendaQuery.dataFinal
      });

      foreach (var row in result)
      {
        var vendaId = row.id;
        if (!vendasDictionary.TryGetValue(vendaId, out Venda venda))
        {
          venda = new Venda
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

        var vendaItem = new VendaItem
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

      return vendasDictionary.Values.ToList();
    }

    public async Task<IEnumerable<Venda>> GetVendasPorUsuarioAsync(VendaQuery vendaQuery, string userId, CancellationToken cancellationToken = default)
    {
      var vendasDictionary = new Dictionary<long, Venda>();

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
	            c.foto_url AS compradorfotourl
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id
            LEFT JOIN venda_itens vi ON v.id = vi.venda_id   
            WHERE c.user_id=@userid
      ";


      if (vendaQuery.dataInicio.HasValue && vendaQuery.dataFinal.HasValue)
      {
        sql += " AND (v.datahora BETWEEN @datainicio AND @datafinal)";
      }
      else if (vendaQuery.dataInicio.HasValue)
      {
        sql += " AND v.datahora > @datainicio";
      }
      else if (vendaQuery.dataFinal.HasValue)
      {
        sql += " AND v.datahora < @datafinal";
      }

      var result = await _dbConnection.QueryAsync<dynamic>(sql, new
      {
        userid = userId,
        datainicio = vendaQuery.dataInicio,
        datafinal = vendaQuery.dataFinal
      });

      foreach (var row in result)
      {
        var vendaId = row.id;
        if (!vendasDictionary.TryGetValue(vendaId, out Venda venda))
        {
          venda = new Venda
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

        var vendaItem = new VendaItem
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

      return vendasDictionary.Values.ToList();
    }

    private VendaDetalhe MapVendaDetalhe(dynamic result)
    {
      var venda = new VendaDetalhe
      {
        Id = result[0].id,
        Status = (EnumVendaStatus)result[0].status,
        DataHora = result[0].datahora,
        Total = result[0].total,
      };

      foreach (dynamic item in result)
      {
        var vendaItem = new VendaItemDetalhe
        {
          ProdutoId = item.itemprodutoid,
          Nome = item.itemnome,
          ImageUrl = item.itemimageurl,
          Preco = item.itempreco,
          Quantidade = item.itemquantidade,
          UnidadeMedida = item.itemunidade,
        };

        venda.Itens.Add(vendaItem);
      }

      return venda;
    }
  }
}
