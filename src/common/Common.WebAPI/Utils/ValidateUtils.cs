using Common.WebAPI.Results;
using System.ComponentModel.DataAnnotations;

namespace Common.WebAPI.Utils
{
  public interface IValidateUtils
  {
    bool ValidateModel<TModel, TResponseModel>(TModel model, ref Result<TResponseModel>? result);
  }

  public class ValidateUtils : IValidateUtils
  {
    public bool ValidateModel<TModel, TResponseModel>(TModel model, ref Result<TResponseModel>? result)
    {
      var context = new ValidationContext(model!);
      var validationResults = new List<ValidationResult>();
      var isValid = Validator.TryValidateObject(model!, context, validationResults, true);

      if (!isValid)
      {
        result = Result.Fail<TResponseModel>(validationResults.Select(e => new ErrorResult(e.ErrorMessage!)).ToArray());
      }

      return isValid;
    }
  }
}
