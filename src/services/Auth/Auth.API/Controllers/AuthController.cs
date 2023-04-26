using Common.WebAPI.Results;
using Microsoft.AspNetCore.Mvc;

namespace Auth.API.Controllers
{
  [Route("api/auth")]
  [ApiController]
  public class AuthController : ControllerBase
  {
    /// <summary>
    /// Endpoint para verificar se o usuário está autorizado
    /// </summary>
    // GET api/auth
    [HttpGet]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public Result GetAsync() => Result.NoContent();
  }
}
