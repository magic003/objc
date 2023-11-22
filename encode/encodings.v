module encode

// An Objective-C type encoding.
//
// For more information, see Apple's documentation:
// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
pub type Encoding = Array
	| BitField
	| Bool
	| Char
	| Class
	| Double
	| Float
	| Int
	| Long
	| LongLong
	| Object
	| Pointer
	| Sel
	| Short
	| String
	| Struct
	| UChar
	| UInt
	| ULong
	| ULongLong
	| UShort
	| Union
	| Unknown
	| Void

pub fn (e Encoding) str() string {
	return match e {
		Char {
			'c'
		}
		Short {
			's'
		}
		Int {
			'i'
		}
		Long {
			'l'
		}
		LongLong {
			'q'
		}
		UChar {
			'C'
		}
		UShort {
			'S'
		}
		UInt {
			'I'
		}
		ULong {
			'L'
		}
		ULongLong {
			'Q'
		}
		Float {
			'f'
		}
		Double {
			'd'
		}
		Bool {
			'B'
		}
		Void {
			'v'
		}
		String {
			'*'
		}
		Object {
			'@'
		}
		Class {
			'#'
		}
		Sel {
			':'
		}
		Array {
			'[${e.len}${e.tp}]'
		}
		Struct {
			mut encoding := '{${e.name}='
			for field in e.fields {
				encoding += field.str()
			}
			encoding += '}'
			return encoding
		}
		Union {
			mut encoding := '(${e.name}='
			for field in e.fields {
				encoding += field.str()
			}
			encoding += ')'
			return encoding
		}
		BitField {
			'b${e.bits}'
		}
		Pointer {
			'^${e.tp}'
		}
		Unknown {
			'?'
		}
	}
}

// A char.
struct Char {}

pub fn Encoding.char() Encoding {
	return Encoding(Char{})
}

// A short.
struct Short {}

pub fn Encoding.short() Encoding {
	return Encoding(Short{})
}

// An int.
struct Int {}

pub fn Encoding.int() Encoding {
	return Encoding(Int{})
}

// A long.
struct Long {}

pub fn Encoding.long() Encoding {
	return Encoding(Long{})
}

// A long long.
struct LongLong {}

pub fn Encoding.long_long() Encoding {
	return Encoding(LongLong{})
}

// An unsigned char.
struct UChar {}

pub fn Encoding.uchar() Encoding {
	return Encoding(UChar{})
}

// An unsigned short.
struct UShort {}

pub fn Encoding.ushort() Encoding {
	return Encoding(UShort{})
}

// An unsigned int.
struct UInt {}

pub fn Encoding.uint() Encoding {
	return Encoding(UInt{})
}

// An unsigned long.
struct ULong {}

pub fn Encoding.ulong() Encoding {
	return Encoding(ULong{})
}

// An unsigned long long.
struct ULongLong {}

pub fn Encoding.ulong_long() Encoding {
	return Encoding(ULongLong{})
}

// A float.
struct Float {}

pub fn Encoding.float() Encoding {
	return Encoding(Float{})
}

// A double.
struct Double {}

pub fn Encoding.double() Encoding {
	return Encoding(Double{})
}

// A bool.
struct Bool {}

pub fn Encoding.bool() Encoding {
	return Encoding(Bool{})
}

// A void.
struct Void {}

pub fn Encoding.void() Encoding {
	return Encoding(Void{})
}

// A character string.
struct String {}

pub fn Encoding.string() Encoding {
	return Encoding(String{})
}

// An object.
struct Object {}

pub fn Encoding.object() Encoding {
	return Encoding(Object{})
}

// A class object.
struct Class {}

pub fn Encoding.class() Encoding {
	return Encoding(Class{})
}

// A method selector.
struct Sel {}

pub fn Encoding.sel() Encoding {
	return Encoding(Sel{})
}

// An Array.
struct Array {
	len int      @[required]
	tp  Encoding @[required]
}

pub fn Encoding.array(len int, tp Encoding) Encoding {
	return Encoding(Array{len, tp})
}

// A structure.
struct Struct {
	name   string     @[required]
	fields []Encoding @[required]
}

pub fn Encoding.@struct(name string, fields []Encoding) Encoding {
	return Encoding(Struct{name, fields})
}

// A union.
struct Union {
	name   string     @[required]
	fields []Encoding @[required]
}

pub fn Encoding.@union(name string, fields []Encoding) Encoding {
	return Encoding(Union{name, fields})
}

// A bit field of num bits.
struct BitField {
	bits int @[required]
}

pub fn Encoding.bit_field(bits int) Encoding {
	return Encoding(BitField{bits})
}

// A pointer to type.
struct Pointer {
	tp Encoding @[required]
}

pub fn Encoding.pointer(tp Encoding) Encoding {
	return Encoding(Pointer{tp})
}

// An unknown type.
struct Unknown {}

pub fn Encoding.unknown() Encoding {
	return Encoding(Unknown{})
}
