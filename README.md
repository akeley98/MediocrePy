# MediocrePy
An aggressively average SIMD python module (array averages with sigma clipping)

Internally, the module uses 256-bit single precision floating point vectors everywhere. This will require the AVX instruction set, introduced in 2011 (Sandy Bridge or later for Intel, Bulldozer or later for AMD, I think). Keep in mind that compilers are often no help when it comes to memory alignment for such vector data types, so be vigilant.

For now this module is GPL because that is my default choice. I can change the license later if that will make the module more useful.

