using Common.WebAPI.Results;
using Dapper;
using System.Data;

namespace Compras.API.Application.Queries
{
  public class ComprasQueries : IComprasQueries
  {
    private readonly IDbConnection _dbConnection;

    public ComprasQueries(IDbConnection dbConnection)
    {
      _dbConnection = dbConnection;
    }

    public async Task<CompraDetalheDto?> GetCompraAsync(long compraId, CancellationToken cancellationToken = default)
    {
      var result = await _dbConnection.QueryAsync<dynamic>(
          @"
            SELECT
             c.id AS id,   
             c.datahora AS datahora,
             c.total AS total,
             c.user_id AS userid,
             c.user_email AS useremail,
             c.user_foto_url AS userfotourl,
             ci.produto_id AS itemprodutoid,
             ci.nome AS itemnome,	 
             ci.image_url AS itemimageurl,
             ci.descricao AS itemdescricao,
             ci.estoque_atual AS itemestoqueatual,
             ci.preco_pago AS itemprecopago,
             ci.preco_sugerido AS itemprecosugerido,
             ci.preco_medio_sugerido AS itemprecomediosugerido,
             ci.quantidade AS itemquantidade,
             ci.unidade_medida AS itemunidademedida
            FROM compras c            
            LEFT JOIN compra_itens ci ON c.id = ci.compra_id
            WHERE c.id=@id
          ", new { id = compraId }
      );

      if (result.AsList().Count == 0)
        return null;

      return MapCompraDetalhe(result);
    }

    public async Task<PagedResult<CompraDto>> GetComprasAsync(CompraQuery compraQuery, CancellationToken cancellationToken = default)
    {
      var comprasDictionary = new Dictionary<long, CompraDto>();

      var sql = @"
          SELECT
             c.id AS id,   
             c.datahora AS datahora,
             c.total AS total,
             c.user_id AS userid,
             c.user_email AS useremail,
             c.user_foto_url AS userfotourl,
             ci.produto_id AS itemprodutoid,
             ci.nome AS itemnome,	 
             ci.image_url AS itemimageurl,
             ci.descricao AS itemdescricao,
             ci.estoque_atual AS itemestoqueatual,
             ci.preco_pago AS itemprecopago,
             ci.preco_sugerido AS itemprecosugerido,
             ci.preco_medio_sugerido AS itemprecomediosugerido,
             ci.quantidade AS itemquantidade,
             ci.unidade_medida AS itemunidademedida,   
             count(*) over() AS count
          FROM compras c
          LEFT JOIN compra_itens ci ON c.id = ci.compra_id  
      ";

      if (compraQuery.dataInicial.HasValue && compraQuery.dataFinal.HasValue)
      {
        sql += " WHERE c.datahora BETWEEN @dataInicial AND @datafinal";
      }
      else if (compraQuery.dataInicial.HasValue)
      {
        sql += " WHERE c.datahora > @dataInicial";
      }
      else if (compraQuery.dataFinal.HasValue)
      {
        sql += " WHERE c.datahora < @datafinal";
      }

      var start = (compraQuery.page - 1) * compraQuery.limit;
      sql += @" 
                ORDER BY c.datahora DESC 
                LIMIT @limit OFFSET @offset;
      ";

      var result = await _dbConnection.QueryAsync<dynamic>(sql, new
      {
        dataInicial = compraQuery.dataInicial,
        datafinal = compraQuery.dataFinal,
        limit = compraQuery.limit,
        offset = start
      });

      foreach (var row in result)
      {
        var compraId = row.id;
        if (!comprasDictionary.TryGetValue(compraId, out CompraDto venda))
        {
          venda = new CompraDto
          {
            Id = compraId,
            DataHora = row.datahora,
            Total = row.total,
            UserId = row.userid,
            UserEmail = row.useremail,
            UserFotoUrl = row.userfotourl
          };
          comprasDictionary.Add(compraId, venda);
        }

        var vendaItem = new CompraItemto
        {
          ProdutoId = row.itemprodutoid,
          Nome = row.itemnome,
          ImageUrl = row.itemimageurl,
          PrecoPago = row.itemprecopago,
          Quantidade = row.itemquantidade,
          UnidadeMedida = row.itemunidademedida
        };
        venda.Itens.Add(vendaItem);
      }

      long total = result.FirstOrDefault()?.count ?? 0;

      return new PagedResult<CompraDto>(start, compraQuery.limit, total, comprasDictionary.Values.ToList());
    }

    private CompraDetalheDto MapCompraDetalhe(dynamic result)
    {
      var compra = new CompraDetalheDto
      {
        Id = result[0].id,
        DataHora = result[0].datahora,
        Total = result[0].total,
        UserId = result[0].userid,
        UserEmail = result[0].useremail,
        UserFotoUrl = result[0].userfotourl
      };

      foreach (dynamic item in result)
      {
        var compraItem = new CompraItemDetalheDto
        {
          ProdutoId = item.itemprodutoid,
          Nome = item.itemnome,
          Descricao = item.itemdescricao,
          ImageUrl = item.itemimageurl,
          PrecoPago = item.itempreco,
          PrecoSugerido = item.itemprecosugerido,
          IsPrecoMedioSugerido = item.itemprecomediosugerido,
          Quantidade = item.itemquantidade,
          UnidadeMedida = item.itemunidademedida,
        };

        compra.Itens.Add(compraItem);
      }

      return compra;
    }
  }
}
