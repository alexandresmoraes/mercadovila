﻿namespace Common.WebAPI.Results
{
  public interface IResultNotFound { }

  public record ResultNotFound : Result, IResultNotFound
  {
    public ResultNotFound() { }
  }
  public record ResultNotFound<T>() : Result<T>(), IResultNotFound { }
}