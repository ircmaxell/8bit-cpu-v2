

class ALU

	def initialize(dataBus, aRegister, bRegister, flagsRegister, carry, invert, zero, func0, func1, func2, enable)
		@dataBus = @dataBus
		@func = 0
		@carry = false
		@invert = false
		@zero = false
		invert.onChange do |value|
			@invert = value
		end
		zero.onChange do |value|
			@zero = value
		end
		carry.onChange do |value|
			@carry = value
		end
		func0.onChange do |value|
			setFunc(value, 0b0001)
		end
		func1.onChange do |value|
			setFunc(value, 0b0010)
		end
		func2.onChange do |value|
			setFunc(value, 0b0100)
		end

		enable.onHigh do
			dataBus.write do 
				value = calculate(aRegister.value, bRegister.value)
				flags = 0
				if value == 0b00000000
					flags = flags | 0b0001
				end
				if 0 != (value & 0b10000000)
					flags = flags | 0b0010
				end
				if value > 0xFF
					flags = flags | 0b0100
				end
				flagsRegister.value = flags
				value & 0xFF
			end
		end
		enable.onLow do 
			dataBus.endWrite 
		end
	end



	private

	def calculate(a, b)
		b = 0 if @zero
		b = ~b if @invert
		a = a + 1 if @carry
		if @func == 0 #add
			a + b
		elsif @func == 1 #and
			a & b
		elsif @func == 2 #or
			a | b
		elsif @func == 3 #xor
			a ^ b
		elsif @func == 4 #sl
			a << b
		elsif @func == 5 #sr
			(a & 0xFF) >> b
		else
			0
		end
	end


	def setFunc(value, bit)
		if value
			@func = @func | bit
		else
			@func = @func & ~bit
		end
	end
end
