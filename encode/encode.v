module encode

import objc
import v.reflection

// encode returns the Objective-C encoding of the type parameter `T`.
pub fn encode[T]() !Encoding {
	return encode_type(T.typ)
}

fn encode_type(idx int) !Encoding {
	if idx == type_idx[objc.Id]() {
		return Encoding.object()
	}
	if idx == type_idx[objc.Sel]() {
		return Encoding.sel()
	}
	if idx == type_idx[objc.Class]() {
		return Encoding.class()
	}
	typ := reflection.get_type(idx) or {
		panic('Cannot get type for ${idx}. It is probably a bug in the library.')
	}
	match typ.sym.kind {
		.i8 {
			return Encoding.char()
		}
		.i16 {
			return Encoding.short()
		}
		.int {
			return Encoding.int()
		}
		.i64 {
			return Encoding.long_long()
		}
		.u8 {
			return Encoding.uchar()
		}
		.u16 {
			return Encoding.ushort()
		}
		.u32 {
			return Encoding.uint()
		}
		.u64 {
			return Encoding.ulong_long()
		}
		.f32 {
			return Encoding.float()
		}
		.f64 {
			return Encoding.double()
		}
		.bool {
			return Encoding.bool()
		}
		.string, .rune {
			return Encoding.string()
		}
		.isize {
			$if amd64 || arm64 || x64 {
				return Encoding.long_long()
			} $else {
				return Encoding.int()
			}
		}
		.usize {
			$if amd64 || arm64 || x64 {
				return Encoding.ulong_long()
			} $else {
				return Encoding.uint()
			}
		}
		.voidptr {
			return Encoding.pointer(Encoding.void())
		}
		.struct_ {
			s := typ.sym.info as reflection.Struct
			mut fields := []Encoding{}
			for field in s.fields {
				fields << encode_type(field.typ.idx())!
			}
			return Encoding.@struct(typ.name, fields)
		}
		.alias {
			a := typ.sym.info as reflection.Alias
			return encode_type(a.parent_idx)
		}
		else {
			return error('cannot encode ${typ.sym.kind} type ${typ.name}')
		}
	}
}

fn type_idx[T]() int {
	return T.typ
}
