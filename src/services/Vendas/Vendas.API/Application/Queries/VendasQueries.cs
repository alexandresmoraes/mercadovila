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
              c.id AS compradoruserid
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
      var sql = @"
            SELECT
	            v.id AS id,
	            v.status AS status,
	            v.datahora AS datahora,
	            v.total AS total,
	            c.nome AS compradornome,
	            c.foto_url AS compradorfotourl,
              count(*) over() AS count
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id          
      ";

      var where = new List<string>();

      if (vendaQuery.dataInicial.HasValue && vendaQuery.dataFinal.HasValue)
      {
        where.Add("v.datahora BETWEEN @dataInicial AND @dataFinal");
      }
      else if (vendaQuery.dataInicial.HasValue)
      {
        where.Add("v.datahora > @dataInicial");
      }
      else if (vendaQuery.dataFinal.HasValue)
      {
        where.Add("v.datahora < @dataFinal");
      }

      if (!string.IsNullOrEmpty(vendaQuery.compradorNome))
      {
        where.Add("c.nome ILIKE @compradorNome");
      }

      if (where.Any())
      {
        sql += " WHERE " + string.Join(" AND ", where);
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
        offset = start,
        compradorNome = $"%{vendaQuery.compradorNome}%",
      });


      List<VendaDto> vendas = new List<VendaDto>();

      foreach (var row in result)
      {
        var vendaId = row.id;

        var venda = new VendaDto
        {
          Id = vendaId,
          Status = (EnumVendaStatus)row.status,
          DataHora = row.datahora,
          Total = row.total,
          CompradorNome = row.compradornome,
          CompradorFotoUrl = row.compradorfotourl,
        };

        var vendaItens = await _dbConnection.QueryAsync<dynamic>(
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
              c.id AS compradoruserid
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id
            LEFT JOIN venda_itens vi ON v.id = vi.venda_id            
            WHERE v.id=@id
          ", new { id = vendaId }
        );

        foreach (var vendaItem in vendaItens)
        {
          venda.Itens.Add(new VendaItemto
          {
            ProdutoId = vendaItem.itemprodutoid,
            Nome = vendaItem.itemnome,
            ImageUrl = vendaItem.itemimageurl,
            Preco = vendaItem.itempreco,
            Quantidade = vendaItem.itemquantidade,
            UnidadeMedida = vendaItem.itemunidademedida
          });
        }

        vendas.Add(venda);
      }

      long total = result.FirstOrDefault()?.count ?? 0;

      return new PagedResult<VendaDto>(start, vendaQuery.limit, total, vendas);
    }

    public async Task<PagedResult<VendaDto>> GetMinhasComprasAsync(VendaQuery vendaQuery, string userId, CancellationToken cancellationToken = default)
    {
      var sql = @"
            SELECT
	            v.id AS id,
	            v.status AS status,
	            v.datahora AS datahora,
	            v.total AS total,
	            c.nome AS compradornome,
	            c.foto_url AS compradorfotourl,
              count(*) over() AS count
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id
            WHERE c.id=@userid
      ";

      if (vendaQuery.dataInicial.HasValue && vendaQuery.dataFinal.HasValue)
      {
        sql += " AND v.datahora BETWEEN @dataInicial AND @datafinal";
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
        limit = vendaQuery.limit,
        offset = start
      });


      List<VendaDto> vendas = new List<VendaDto>();

      foreach (var row in result)
      {
        var vendaId = row.id;

        var venda = new VendaDto
        {
          Id = vendaId,
          Status = (EnumVendaStatus)row.status,
          DataHora = row.datahora,
          Total = row.total,
          CompradorNome = row.compradornome,
          CompradorFotoUrl = row.compradorfotourl,
        };

        var vendaItens = await _dbConnection.QueryAsync<dynamic>(
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
              c.id AS compradoruserid
            FROM vendas v
            LEFT JOIN compradores c ON c.id = v.comprador_id
            LEFT JOIN venda_itens vi ON v.id = vi.venda_id            
            WHERE v.id=@id
          ", new { id = vendaId }
        );

        foreach (var vendaItem in vendaItens)
        {
          venda.Itens.Add(new VendaItemto
          {
            ProdutoId = vendaItem.itemprodutoid,
            Nome = vendaItem.itemnome,
            ImageUrl = vendaItem.itemimageurl,
            Preco = vendaItem.itempreco,
            Quantidade = vendaItem.itemquantidade,
            UnidadeMedida = vendaItem.itemunidademedida
          });
        }

        vendas.Add(venda);
      }

      long total = result.FirstOrDefault()?.count ?? 0;

      return new PagedResult<VendaDto>(start, vendaQuery.limit, total, vendas);
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

    public async Task<bool> PagoEmDinheiro(long vendaId, CancellationToken cancellationToken = default)
    {
      const string pagamentoQuery = @"
        SELECT p.tipo
        FROM pagamentos p
        INNER JOIN vendas v ON p.id = v.pagamento_id
        WHERE v.Id = @vendaId";

      var tipoPagamento = await _dbConnection.QuerySingleOrDefaultAsync<EnumTipoPagamento>(pagamentoQuery, new { vendaId });

      return tipoPagamento == EnumTipoPagamento.Dinheiro;
    }
  }
}
