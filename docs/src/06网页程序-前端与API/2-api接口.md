REopt 是由美国国家可再生能源实验室（NREL）开发的用于优化分布式能源系统设计的工具。它有一个API（应用程序接口），可以帮助开发者通过程序自动化地与REopt进行交互，用于评估、设计和优化综合能源系统。以下是REopt API 的基本介绍：

### 1. **REopt API 概述**
REopt API 主要用于评估分布式能源资源的技术和经济可行性，包括：
- 可再生能源（如太阳能、风能）
- 储能系统（如电池、热储能）
- 微电网配置
- 能源负荷管理

REopt 的API允许用户通过提供建筑能耗、能源成本、设备成本等输入数据，来获取系统设计的建议和优化结果。

### 2. **API 端点**
主要的API端点用于与REopt模型进行通信。一般来说，包含以下关键部分：
- **POST /v1/job**: 发送一个优化任务请求，提交你所需的能源系统输入数据。
- **GET /v1/job/{job_id}/results**: 获取特定任务的优化结果，包括建议的系统配置、节约成本等。

### 3. **请求参数（输入数据）**
REopt API 允许用户通过JSON格式发送输入数据。常见的输入数据包括：
- **Site 信息**: 包括建筑的位置、面积、能耗数据等。
- **Financial 数据**: 包括电价、燃料成本、投资预算等。
- **技术信息**: 包括太阳能、电池、风能等技术的成本和技术参数。
- **时间数据**: 用于定义不同季节或时间段的能源消耗模式。
  
**示例**:
```json
{
  "Site": {
    "latitude": 39.7392,
    "longitude": -104.9903,
    "ElectricTariff": {
      "urdb_label": "5c65d57b5457a30001254d00"
    },
    "LoadProfile": {
      "yearly_kwh": 100000,
      "doe_reference_name": "MidriseApartment"
    }
  },
  "PV": {
    "max_kw": 100,
    "installed_cost_us_dollars_per_kw": 2000
  },
  "Storage": {
    "max_kwh": 500,
    "installed_cost_us_dollars_per_kw": 500
  }
}
```

### 4. **返回结果**
API会返回一个 `job_id`，你可以通过 `GET /v1/job/{job_id}/results` 来获取优化结果。返回的数据通常包括：
- **最佳系统配置**: 比如需要安装多少光伏、储能设备。
- **经济分析**: 如节省的成本、投资回报期。
- **技术分析**: 系统运行效率、能耗分布等。

**示例返回结果**:
```json
{
  "outputs": {
    "PV": {
      "size_kw": 50,
      "annual_kwh": 75000,
      "npv_us_dollars": 20000
    },
    "Storage": {
      "size_kwh": 250,
      "size_kw": 50,
      "npv_us_dollars": 10000
    },
    "Financial": {
      "lcc_us_dollars": 500000,
      "npv_us_dollars": 30000
    }
  }
}
```

### 5. **应用场景**
REopt API 可以用于：
- 优化设计混合能源系统的规模和配置。
- 评估不同的能源策略（如节能措施、可再生能源利用）。
- 制定能源投资决策。
- 分析微电网和储能系统的技术经济性。

如果你想让团队深入了解REopt API，可以访问其[官方文档](https://developer.nrel.gov/docs/energy-optimization/reopt/v1/)来获取更详细的介绍和使用示例。