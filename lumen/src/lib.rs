use std::ffi::CString;
use tesseract_sys::*;

#[no_mangle]
pub extern "C" fn processOCR(image: *const u8, length: usize) -> *const i8 {
    let api = unsafe { TessBaseAPICreate() };
    let lang = CString::new("eng").unwrap();
    unsafe {TessBaseAPIInit3(api, std::ptr::null(), lang.as_ptr());}
    unsafe {TessBaseAPISetImage(api, image, length as i32, 1, 1, 1);}
    let text = unsafe {TessBaseAPIGetUTF8Text(api)};
    unsafe {TessBaseAPIEnd(api)};
    unsafe {TessBaseAPIDelete(api)};
    text
    
    
}    
