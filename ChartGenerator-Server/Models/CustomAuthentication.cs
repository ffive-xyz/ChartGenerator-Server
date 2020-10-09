using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ChartGenerator_Server.Models
{
    public class CustomAuthentication
    {
        #region Public Properties

        public List<string> Origins { get; set; }
        public string Key { get; set; }

        #endregion Public Properties
    }
}