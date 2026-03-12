import 'package:virnavi_ai_agent_mcp/virnavi_ai_agent_mcp.dart';

import 'src/helper/hijri_helper.dart';
import 'src/salah/models/config/models.dart';
import 'src/salah/models/salah_times.dart';
import 'src/services/islamic_calculator_service.dart';
import 'src/zakat/zakat_calculator.dart';

export 'src/salah/enums/enums.dart';
export 'src/salah/models/salah_times.dart';
export 'src/celestial/sun_time_table.dart';
export 'src/salah/models/config/models.dart' show CountryConfig, SalahCalculationMethod, SalahTimeConfig;
export 'src/helper/hijri_helper.dart';
export 'src/zakat/zakat_calculator.dart';
export 'src/services/islamic_calculator_service.dart';

//export 'src/data/data.dart';
//export 'src/models/models.dart';

part 'virnavi_islamic_calculator.mcp.dart';

/// MCP summary for the virnavi_islamic_calculator package.
///
/// Use [IslamicCalculatorSummary.bindAll] to register all tools and schemas
/// with the [AgentBridge] in a single call.
@McpSummary()
class IslamicCalculatorSummary {}
