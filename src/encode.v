module objc

import encode as ec
import v.reflection

// encode returns the Objective-C encoding of the type parameter `T`.
pub fn encode[T]() !ec.Encoding {
	return encode_type(T.typ)
}

const objc_encoding_name_attr = 'objc_encoding_name='

fn encode_type(idx int) !ec.Encoding {
	if idx == type_idx[Id]() {
		return ec.Encoding.object()
	}
	if idx == type_idx[Sel]() {
		return ec.Encoding.sel()
	}
	if idx == type_idx[Class]() {
		return ec.Encoding.class()
	}
	typ := reflection.get_type(idx) or {
		panic('Cannot get type for ${idx}. It is probably a bug in the library.')
	}
	match typ.sym.kind {
		.i8 {
			return ec.Encoding.char()
		}
		.i16 {
			return ec.Encoding.short()
		}
		.int {
			return ec.Encoding.int()
		}
		.i64 {
			return ec.Encoding.long_long()
		}
		.u8 {
			return ec.Encoding.uchar()
		}
		.u16 {
			return ec.Encoding.ushort()
		}
		.u32 {
			return ec.Encoding.uint()
		}
		.u64 {
			return ec.Encoding.ulong_long()
		}
		.f32 {
			return ec.Encoding.float()
		}
		.f64 {
			return ec.Encoding.double()
		}
		.bool {
			return ec.Encoding.bool()
		}
		.string, .rune {
			return ec.Encoding.string()
		}
		.isize {
			$if amd64 || arm64 || x64 {
				return ec.Encoding.long_long()
			} $else {
				return ec.Encoding.int()
			}
		}
		.usize {
			$if amd64 || arm64 || x64 {
				return ec.Encoding.ulong_long()
			} $else {
				return ec.Encoding.uint()
			}
		}
		.voidptr {
			return ec.Encoding.pointer(ec.Encoding.void())
		}
		.struct_ {
			s := typ.sym.info as reflection.Struct

			mut name := typ.name
			for attr in s.attrs {
				if attr.contains(objc.objc_encoding_name_attr) {
					name = attr.replace(objc.objc_encoding_name_attr, '').trim(' ')
					break
				}
			}
			mut fields := []ec.Encoding{}
			for field in s.fields {
				fields << encode_type(field.typ.idx())!
			}
			return ec.Encoding.@struct(name, fields)
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
