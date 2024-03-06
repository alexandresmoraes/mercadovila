using Common.WebAPI.Results;

namespace Compras.API.Application.Queries
{
  public class ComprasQueries : IComprasQueries
  {
    public Task<PagedResult<CompraDto>> GetComprasAsync(CompraQuery compraQuery, CancellationToken cancellationToken = default)
    {
      // TODO
      throw new NotImplementedException();

      //var comprasDictionary = new Dictionary<long, CompraDto>();

      //var sql = @"
      //      SELECT
      //       v.id AS id,
      //       v.status AS status,
      //       v.datahora AS datahora,
      //       v.total AS total,
      //       vi.produto_id AS itemprodutoid,
      //       vi.nome AS itemnome, 
      //       vi.image_url AS itemimageurl,
      //       vi.preco AS itempreco,
      //       vi.quantidade AS itemquantidade,
      //       vi.unidade_medida AS itemunidademedida,
      //       c.nome AS compradornome,
      //       c.foto_url AS compradorfotourl,
      //        count(*) over() AS count
      //      FROM vendas v
      //      LEFT JOIN compradores c ON c.id = v.comprador_id
      //      LEFT JOIN venda_itens vi ON v.id = vi.venda_id            
      //";

      //if (CompraDto.dataInicial.HasValue && CompraDto.dataFinal.HasValue)
      //{
      //  sql += " WHERE v.datahora BETWEEN @dataInicial AND @datafinal";
      //}
      //else if (CompraDto.dataInicial.HasValue)
      //{
      //  sql += " WHERE v.datahora > @dataInicial";
      //}
      //else if (CompraDto.dataFinal.HasValue)
      //{
      //  sql += " WHERE v.datahora < @datafinal";
      //}

      //var start = (CompraDto.page - 1) * CompraDto.limit;
      //sql += @" 
      //          ORDER BY v.datahora DESC 
      //          LIMIT @limit OFFSET @offset;
      //";

      //var result = await _dbConnection.QueryAsync<dynamic>(sql, new
      //{
      //  dataInicial = vendaQuery.dataInicial,
      //  datafinal = vendaQuery.dataFinal,
      //  limit = vendaQuery.limit,
      //  offset = start
      //});

      //foreach (var row in result)
      //{
      //  var vendaId = row.id;
      //  if (!comprasDictionary.TryGetValue(vendaId, out CompraDto venda))
      //  {
      //    venda = new CompraDto
      //    {
      //      Id = vendaId,
      //      Status = (EnumVendaStatus)row.status,
      //      DataHora = row.datahora,
      //      Total = row.total,
      //      CompradorNome = row.compradornome,
      //      CompradorFotoUrl = row.compradorfotourl,
      //    };
      //    comprasDictionary.Add(vendaId, venda);
      //  }

      //  var vendaItem = new VendaItemto
      //  {
      //    ProdutoId = row.itemprodutoid,
      //    Nome = row.itemnome,
      //    ImageUrl = row.itemimageurl,
      //    Preco = row.itempreco,
      //    Quantidade = row.itemquantidade,
      //    UnidadeMedida = row.itemunidademedida
      //  };
      //  venda.Itens.Add(vendaItem);
      //}

      //long total = result.FirstOrDefault()?.count ?? 0;

      //return new PagedResult<CompraDto>(start, compraQuery.limit, total, comprasDictionary.Values.ToList());
    }
  }
}
