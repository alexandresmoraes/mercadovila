using Microsoft.EntityFrameworkCore.Storage;
using Npgsql.EntityFrameworkCore.PostgreSQL.Storage.Internal;
using System.Text;

namespace Common.WebAPI.Data
{
  public class NpgsqlSqlGenerationLowercasingHelper : NpgsqlSqlGenerationHelper
  {
    const string dontAlter = "__EFMigrationsHistory";
    static string Customize(string input) => input == dontAlter ? input : input.ToLower();
    public NpgsqlSqlGenerationLowercasingHelper(RelationalSqlGenerationHelperDependencies dependencies)
        : base(dependencies) { }
    public override string DelimitIdentifier(string identifier)
        => base.DelimitIdentifier(Customize(identifier));
    public override void DelimitIdentifier(StringBuilder builder, string identifier)
        => base.DelimitIdentifier(builder, Customize(identifier));
  }
}