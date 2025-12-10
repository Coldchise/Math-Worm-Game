class_name DatetimeUtils
## Original File MIT License Copyright (c) 2024 TinyTakinTeller


## Some OS will return weird symbols in the name field, we want to avoid unexpected parsing errors.
static func get_time_zone_from_system() -> Dictionary:
	var timezone: Dictionary = Time.get_time_zone_from_system()
	timezone["bias"] = int(timezone.get("bias", 0))
	timezone["name"] = StringUtils.sanitize_text(timezone.get("name", "unknown"))
	return timezone


## Convert given datetime by taking into consideration the timezone bias (in minutes).
static func convert_datetime(datetime: Dictionary, timezone: Dictionary) -> Dictionary:
	if datetime.is_empty():
		return datetime
	var unix: int = Time.get_unix_time_from_datetime_dict(datetime)
	unix += timezone.get("bias", 0) * 60
	return Time.get_datetime_dict_from_unix_time(unix)


## Difference in seconds between two datetime dictionaries.
static func difference_seconds(start: Dictionary, end: Dictionary) -> int:
	var start_unix: int = Time.get_unix_time_from_datetime_dict(start) if start != {} else 0
	var end_unix: int = Time.get_unix_time_from_datetime_dict(end) if end != {} else 0
	return end_unix - start_unix


static func format_datetime(d: Dictionary, format: String = "{z}.{x}.{y} {h}:{m}:{s}") -> String:
	var y: String = _zero_prefix(d.get("year", 0))
	var x: String = _zero_prefix(d.get("month", 0))
	var z: String = _zero_prefix(d.get("day", 0))
	var h: String = _zero_prefix(d.get("hour", 0))
	var m: String = _zero_prefix(d.get("minute", 0))
	var s: String = _zero_prefix(d.get("second", 0))
	return format.format({"y": y, "x": x, "z": z, "h": h, "m": m, "s": s})


static func format_seconds(amount: int, format: String = "{h}h : {m}m : {s}s") -> String:
	var hours: int = amount / 3600
	var minutes: int = (amount / 60) % 60
	var seconds: int = amount % 60
	var h: String = str(hours)

	var mm: String = _zero_prefix(minutes)
	var ss: String = _zero_prefix(seconds)
	return format.format({"h": h, "m": mm, "s": ss})


## Ensures result is at least 2 digits: 00, 01, 02, ..., 10, 11, ...
static func _zero_prefix(n: int) -> String:
	return str(n) if n > 9 else "0" + str(n)
