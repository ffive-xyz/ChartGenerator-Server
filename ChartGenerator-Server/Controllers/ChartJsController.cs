using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ChartGeneratorChartJs;
using ChartGeneratorChartJs.Config;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace ChartGenerator_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChartJsController : ControllerBase
    {
        #region Private Fields

        private readonly ILogger<ChartJsController> logger;

        private readonly ImageChartGenerator imageChartGenerator;

        #endregion Private Fields

        #region Public Constructors

        public ChartJsController(ILogger<ChartJsController> logger, ImageChartGenerator imageChartGenerator)
        {
            this.logger = logger;
            this.imageChartGenerator = imageChartGenerator;
        }

        #endregion Public Constructors

        #region Public Methods

        [HttpPost]
        public async Task<string> CreateChart(ChartConfig chartConfig)
        {
            var bytes = await imageChartGenerator.GenerateChartAsync(chartConfig);
            return Convert.ToBase64String(bytes);
        }

        #endregion Public Methods
    }
}