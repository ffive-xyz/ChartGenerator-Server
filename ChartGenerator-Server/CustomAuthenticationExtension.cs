using ChartGenerator_Server.Models;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Primitives;
using System;
using System.Buffers;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChartGenerator_Server
{
    public static class CustomAuthenticationExtension
    {
        #region Public Methods

        public static IApplicationBuilder UseCustomAuthentication(this IApplicationBuilder app)
        {
            return app.UseMiddleware<CustomAuthenticationMiddleware>();
        }

        #endregion Public Methods
    }

    public class CustomAuthenticationMiddleware
    {
        #region Private Fields

        private readonly RequestDelegate _next;
        private readonly CustomAuthentication customAuthentication;

        #endregion Private Fields

        #region Public Constructors

        public CustomAuthenticationMiddleware(RequestDelegate next, IOptions<CustomAuthentication> customAuthenticationOptions)
        {
            _next = next;
            customAuthentication = customAuthenticationOptions.Value;
        }

        #endregion Public Constructors

        #region Public Methods

        public async Task InvokeAsync(HttpContext httpContext)
        {
            var originCheck = customAuthentication.Origins.Contains(httpContext.Request.Host.Host) || customAuthentication.Origins.Contains("*");
            StringValues keyValue;
            var keyCheck = httpContext.Request.Headers.TryGetValue("key", out keyValue) && keyValue.ToArray()[0] == customAuthentication.Key;

            if (httpContext.Request.Method.ToLower() == "post" && (!originCheck || !keyCheck))
            {
                httpContext.Response.StatusCode = StatusCodes.Status401Unauthorized;
                await httpContext.Response.WriteAsync("Invalid key or not in origins list");
                httpContext.Request.Path = "/unauthorized";
                return;
            }
            await _next(httpContext);
        }

        #endregion Public Methods
    }
}