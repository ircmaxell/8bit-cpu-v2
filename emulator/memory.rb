
class Memory

	def initialize(clock, addressBus, dataBus, readControl, writeControl, registers, rom)
		@address = 0
		@doRead = false
		@dataBus = dataBus

		clock.afterTickHigh do 
			@address = addressBus.value
			if @doRead
				result = read
				puts "Reading memory address #{"%04X" % @address}: #{"%02X" % result}"
				@dataBus.value = result
			end
			@doRead = false
		end

		readControl.onHigh do 
			@doRead = true
		end

		readControl.onLow do
			@dataBus.endWrite
		end

		writeControl.onHigh do 
			@dataBus.read do |value|
				write(value)
			end
		end

		@rom = rom
		@registers = registers
		@ram = {}
		@registerMap = {
			0x0000 => :a,
			0x0001 => :b,
			0x0002 => :m1,
			0x0003 => :m2,
			0x0004 => :pc1,
			0x0005 => :pc2,
			0x0006 => :instruction,
			0x0007 => :flags,
		}
		@consts = {
			0x0008 => 0x00,
			0x0009 => 0xFF,
			0x000A => 0x7F,
			0x000B => 0xC0,
		}
	end

	def dump_state
		@ram.each do |key, value|
			puts "  #{"%04X" % key}: #{"%02X" % value}"
		end
	end

	private
	def read
		throw "Dirty memory read" if @address.nil?
		return @registers[@registerMap[@address]].value if @registerMap.has_key?(@address)
		return @consts[@address] if @consts.has_key?(@address)
		return 0 if @address < 0x000F
		return readRam if @address < 0x7FFF
		return readIO if @address < 0xBFFF
		readRom
	end

	def write(value)
		puts "Writing #{"%02X" % value} at memory address #{"%04X" % @address}"

		return @registers[@registerMap[@address]].value = value if @registerMap.has_key?(@address)
		return 0 if @address < 0x000F
		return writeRam(value) if @address < 0x7FFF
		return writeIO(value) if @address < 0xBFFF
		0
	end

	def readIO
		0
	end

	def writeIO(value)
		0
	end

	def readRam
		@ram[@address] || 0
	end

	def readRom
		@rom[@address - 0xC000] || 0
	end

	def writeRam(value)
		@ram[@address] = value
	end


end