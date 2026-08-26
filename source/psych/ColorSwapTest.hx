class ColorSwapTest extends CustomShader{
	public var shader(default, null):ColorSwapShader = new ColorSwapShader();
	public var hue(default, set):Float = 0;
	public var saturation(default, set):Float = 0;
	public var brightness(default, set):Float = 0;

	private function set_hue(value:Float) {
		shader.uHsv.value[0] = value;
		return hue = value;
	}

	private function set_saturation(value:Float) {
		shader.uHsv.value[1] = value;
		return saturation = value;
	}

	private function set_brightness(value:Float) {
		shader.uHsv.value[2] = value;
		return brightness = value;
	}

	public function new()
	{
		shader.uHsv.value = [0, 0, 0];
	}
}