from sys.ffi import external_call, OwnedDLHandle
from memory import UnsafePointer

alias Pointer = UnsafePointer[mut=True, _, MutAnyOrigin]
alias VoidPointer = Pointer[NoneType]

struct ffi_type:
    var size: Int
    var alignment: UInt16
    var type_id: UInt16
    var elements: UnsafePointer[mut=True, UnsafePointer[mut=True, NoneType, MutAnyOrigin], MutAnyOrigin]

struct ffi_cif:
    var abi: UInt32
    var nargs: UInt32
    var arg_types: UnsafePointer[mut=True, UnsafePointer[mut=True, NoneType, MutAnyOrigin], MutAnyOrigin]
    var rtype: UnsafePointer[mut=True, ffi_type, MutAnyOrigin]
    var bytes: UInt32
    var flags: UInt32

def prep_cif(
    cif: UnsafePointer[mut=True, ffi_cif, MutAnyOrigin], 
    abi: UInt32, 
    nargs: UInt32, 
    rtype: UnsafePointer[mut=True, NoneType, MutAnyOrigin], 
    atypes: UnsafePointer[mut=True, UnsafePointer[mut=True, NoneType, MutAnyOrigin], MutAnyOrigin]
) -> Int:
    lib = OwnedDLHandle("/usr/lib/libffi.so")
    func = lib.get_function[fn(Pointer[ffi_cif], UInt32, UInt32, VoidPointer, Pointer[VoidPointer]) -> Int]("ffi_prep_cif")
    return func(cif, abi, nargs, rtype, atypes)

def call(
    cif: UnsafePointer[mut=True, ffi_cif, MutAnyOrigin],
    fn_addr: UnsafePointer[mut=True, NoneType, MutAnyOrigin],
    rvalue: UnsafePointer[mut=True, NoneType, MutAnyOrigin],
    avalue: UnsafePointer[mut=True, UnsafePointer[mut=True, NoneType, MutAnyOrigin], MutAnyOrigin]
) -> None:
    lib = OwnedDLHandle("/usr/lib/libffi.so")
    func = lib.get_function[fn(Pointer[ffi_cif], VoidPointer, VoidPointer, Pointer[VoidPointer]) -> None]("ffi_call")
    func(cif, fn_addr, rvalue, avalue)