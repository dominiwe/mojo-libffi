from io import input
from sys.ffi import OwnedDLHandle, external_call
from memory import UnsafePointer, alloc
from ffi import ffi_cif, ffi_type, prep_cif, call

alias Pointer = UnsafePointer[mut=True, _, MutAnyOrigin]
alias VoidPointer = Pointer[NoneType]

def main():
    lib_path = input("Enter lib path: " )
    lib = OwnedDLHandle(lib_path)
    libffi = OwnedDLHandle("libffi.so")
    t_int_sym = libffi.get_symbol[ffi_type]("ffi_type_sint32")
    t_int = Pointer[ffi_type](unsafe_from_address=Int(t_int_sym))
    while True:
        command = input("> ")
        parts = command.split(" ")
        func_name = parts[0]
        func_sym = lib.get_symbol[NoneType](func_name)
        func = VoidPointer(unsafe_from_address=Int(func_sym))
        args_len = len(parts) - 1
        atypes = alloc[Pointer[ffi_type]](args_len)
        avalues = alloc[VoidPointer](args_len)
        adata = alloc[Int32](args_len)
        for i in range(args_len):
            atypes[i] = t_int
            adata[i] = Int32(atol(parts[i+1]))
            avalues[i] = (adata + i).bitcast[NoneType]()
        cif = alloc[ffi_cif](1)
        _ = prep_cif(cif, 2, UInt32(args_len), t_int.bitcast[NoneType](), atypes.bitcast[VoidPointer]())
        res = alloc[Int32](1)
        
        call(cif, func, res.bitcast[NoneType](), avalues)
        print(res[0])
        
        atypes.free()
        avalues.free()
        adata.free()
        cif.free()
        res.free()
