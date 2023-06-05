namespace Auth.API.Models
{
  public record RefreshTokenModel
  {
    public string RefreshToken { get; set; } = null!;
  }
}
