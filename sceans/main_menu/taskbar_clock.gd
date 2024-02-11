extends Label

var time = Time.get_datetime_dict_from_system()

func _process(_delta):
	text = "  %0*d:%0*d\n%0*d.%0*d.30XX" % [2, time["hour"], 2, time["minute"], 2, time["day"], 2, time["month"]]
	time = Time.get_datetime_dict_from_system()
