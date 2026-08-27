#include <vector>
#include <string>


// `M × N × O` matrix
#define M 2
#define N 3
#define O 4

// Dynamically allocate memory for 3D Array
int I7AMOD()
{
	// dynamically allocate memory of size `M × N × O`
	int* A = (int*)malloc(M * N * O * sizeof(int));

	if (A == NULL)
	{
		fprintf(stderr, "Out of memory");
		exit(0);
	}

	// assign values to the allocated memory
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++)
		{
			for (int k = 0; k < O; k++) {
				*(A + i*N*O + j*O + k) = rand() % 100;
			}
		}
	}

	// print the 3D array
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++)
		{
			for (int k = 0; k < O; k++) {
				printf("%d ", *(A + i*N*O + j*O + k));
			}

			printf("\n");
		}
		printf("\n");
	}

	// deallocate memory
	free(A);

	return 0;
}#include <iostream>

using namespace std;

// Determine if the first string can be transformed into the
// second string with a single edit operation
bool checkEditDistance(string first, string second)
{
	// store length of both strings
	int m = first.length();
	int n = second.length();

	// difference between the length of both strings is more than one
	if (abs(m - n) > 1) {
		return false;
	}

	// to keep track of the total number of edits
	int edits = 0;

	// `i` and `j` keep track of the index of current characters in the
	// first and second strings, respectively

	int i = 0, j = 0;

	// loop till either string runs out
	while (i < m && j < n)
	{
		// if the current character of both strings doesn't match
		if (first[i] != second[j])
		{
			// when the length of the first string is more than the length
			// of the second string,
			// remove the current character at index `i` in the first string

			if (m > n) {
				i++;
			}

			// when the length of the first string is less than the length
			// of the second string, add the current character at index `j`
			// in the second string to the first string

			else if (m < n) {
				j++;
			}

			// when the length of both strings is the same, replace the character
			// present at index `i` in the first string with the character present
			// at index `j` in the second string.

			else {
				i++, j++;
			}

			// increment the number of edits
			edits++;
		}

		// if the current character of both strings matches
		else {
			i++, j++;
		}
	}

	// remove any extra characters left in the first string
	if (i < m) {
		edits++;
	}

	// add any extra characters left in the second string to
	// the end of the first string

	if (j < n) {
		edits++;
	}

	// return true if the number of edits is exactly one;
	// return false otherwise

	return (edits == 1);
}

int END()
{
	cout << boolalpha;

	cout << checkEditDistance("xyz", "xz") << endl; 	// true
	cout << checkEditDistance("xyz", "xyyz") << endl;   // true
	cout << checkEditDistance("xyz", "xyx") << endl;	// true
	cout << checkEditDistance("xyz", "xxx") << endl;	// false

	return 0;

#include <stdio.h>
#include <stdlib.h>

// `M × N × O` matrix
#define M 2
#define N 3
#define O 4

// Dynamically allocate memory for 3D Array
int hash()
{
	int*** A = (int***)malloc(M * sizeof(int**));

	if (A == NULL)
	{
		fprintf(stderr, "Out of memory");
		exit(0);
	}

	for (int i = 0; i < M; i++)
	{
		A[i] = (int**)malloc(N * sizeof(int*));

		if (A[i] == NULL)
		{
			fprintf(stderr, "Out of memory");
			exit(0);
		}

		for (int j = 0; j < N; j++)
		{
			A[i][j] = (int*)malloc(O * sizeof(int));
			if (A[i][j] == NULL)
			{
				fprintf(stderr, "Out of memory");
				exit(0);
			}
		}
	}

	// assign values to the allocated memory
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++)
		{
			for (int k = 0; k < O; k++) {
				A[i][j][k] = rand() % 100;
			}
		}
	}

	// print the 3D array
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++)
		{
			for (int k = 0; k < O; k++) {
				printf("%d ", A[i][j][k]);
			}
			printf("\n");
		}
		printf("\n");
	}

	// deallocate memory
	for (int i = 0; i < M; i++)
	{
		for (int j = 0; j < N; j++) {
			free(A[i][j]);
		}
		free(A[i]);
	}
	free(A);

	return 0; //
//  KittyMemory.cpp
//
//
//  Created by MJ (Ruit) on 1/1/19.
//
//

#include "KittyMemory.hpp"
#include <substrate.h>


using KittyMemory::Memory_Status;


// may not be accurate
static bool cydiaExist(){
  bool ret = false;
  FILE *f = NULL;
  if(( f = fopen( "/Applications/Cydia.app" , "r" ) ) 
  || ( f = fopen( "/Library/MobileSubstrate/MobileSubstrate.dylib" , "r" ) )){
      ret = true;
  }
  if(f != NULL){
    fclose(f);
  }
  return ret;
}

typedef void (*MSHookMemory_t)(void *, const void *, size_t);
inline bool findMSHookMemory(void *dst, const void *src, size_t len){
  static void *ret = MSFindSymbol(NULL, "_MSHookMemory");
  if(ret != NULL){
    reinterpret_cast<MSHookMemory_t>(ret)(dst, src, len);
    return true;
  }
  return false;
}


extern "C" kern_return_t mach_vm_remap(vm_map_t, mach_vm_address_t *, mach_vm_size_t,
                                  mach_vm_offset_t, int, vm_map_t, mach_vm_address_t,
                                  boolean_t, vm_prot_t *, vm_prot_t *, vm_inherit_t);


bool KittyMemory::ProtectAddr(void *address, size_t length, int protection, bool aligned) {
    if(aligned)
        return mprotect(address, length, protection) != -1;

    uintptr_t pageStart = _PAGE_START_OF_(address);
    uintptr_t pageLen   = _PAGE_LEN_OF_(address, length);
    return mprotect(reinterpret_cast<void *>(pageStart), pageLen, protection) != -1;
}


kern_return_t KittyMemory::getPageInfo(void *page_start, vm_region_submap_short_info_64 *outInfo) {
    vm_address_t region  = reinterpret_cast<vm_address_t>(page_start);
    vm_size_t region_len = 0;
    mach_msg_type_number_t info_count = VM_REGION_SUBMAP_SHORT_INFO_COUNT_64;
    unsigned int depth = 0;
    return vm_region_recurse_64(mach_task_self(), &region, &region_len,
                                            &depth,
                                            (vm_region_recurse_info_t) outInfo,
                                            &info_count);
}


/*
refs to
- https://github.com/asLody/whale/blob/master/whale/src/platform/memory.cc
- CydiaSubstrate
*/
Memory_Status KittyMemory::memWrite(void *address, const void *buffer, size_t len) {
	if (address == NULL)
        return INV_ADDR;

    if (buffer == NULL)
        return INV_BUF;

    if (len < 1 || len > INT_MAX)
        return INV_LEN;
	
	// check for MSHookMemory that was added recently, but check for cydia existance first.
    if(cydiaExist() && findMSHookMemory(address, buffer, len)){ 
       return SUCCESS;
     }

    void * page_start  = reinterpret_cast<void *>(_PAGE_START_OF_(address));
    void * page_offset = reinterpret_cast<void *>(_PAGE_OFFSET_OF_(address));
    size_t page_len    = _PAGE_LEN_OF_(address, len);

    vm_region_submap_short_info_64 page_info;
    if(BAD_KERN_CALL(getPageInfo(page_start, &page_info)))
        return INV_KERN_CALL;

    if(page_info.protection & VM_PROT_WRITE){
        if(memcpy(address, buffer, len) != NULL){
           return SUCCESS;
        } else {
           return FAILED;
        }
    }

    void *new_map = mmap(NULL, page_len, _PROT_RW_, MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
    if(new_map == NULL)
        return INV_MAP;

    task_t self_task = mach_task_self();


    if(BAD_KERN_CALL(vm_copy(self_task,
	                  reinterpret_cast<vm_address_t>(page_start), page_len, reinterpret_cast<vm_address_t>(new_map))))
        return INV_KERN_CALL;


    void *dst = reinterpret_cast<void *>(reinterpret_cast<uintptr_t>(new_map) + reinterpret_cast<uintptr_t>(page_offset));
    if(memcpy(dst, buffer, len) == NULL || !ProtectAddr(new_map, page_len, _PROT_RX_, true))
        return FAILED;

    vm_prot_t cur_protection, max_protection;
    mach_vm_address_t mach_vm_page_start = reinterpret_cast<mach_vm_address_t>(page_start);
    if(BAD_KERN_CALL(mach_vm_remap(self_task, &mach_vm_page_start, page_len, 0, VM_FLAGS_OVERWRITE,
                  self_task, reinterpret_cast<mach_vm_address_t>(new_map), TRUE, &cur_protection, &max_protection,
                  page_info.inheritance)))
        return INV_KERN_CALL;

    return SUCCESS;
}


Memory_Status KittyMemory::memRead(void *buffer, const void *addr, size_t len) {
    if (addr == NULL)
        return INV_ADDR;

    if (buffer == NULL)
        return INV_BUF;

    if (len < 1 || len > INT_MAX)
        return INV_LEN;

    if (memcpy(buffer, addr, len) != NULL)
        return SUCCESS;

    return FAILED;
}


std::string KittyMemory::read2HexStr(const void *addr, size_t len) {
    char temp[len];
    memset(temp, 0, len);

    const size_t bufferLen = len * 2 + 1;
    char buffer[bufferLen];
    memset(buffer, 0, bufferLen);

    std::string ret;

    if (memRead(temp, addr, len) != SUCCESS)
        return ret;

    for (int i = 0; i < len; i++) {
        sprintf(&buffer[i * 2], "%02X", (unsigned char) temp[i]);
    }

    ret += buffer;
    return ret;
}


KittyMemory::memory_file_info KittyMemory::getBaseInfo(){
    memory_file_info _info = {
        0,
        _dyld_get_image_header(0),
        _dyld_get_image_name(0),
        _dyld_get_image_vmaddr_slide(0)
    };
    return _info;
}



KittyMemory::memory_file_info KittyMemory::getMemoryFileInfo(const char *fileName){
    memory_file_info _info;

    int imageCount = _dyld_image_count();

    for(int i = 0; i < imageCount; i++) {
        const char *name = _dyld_get_image_name(i);
        const mach_header *header = _dyld_get_image_header(i);
        if(!strstr(name, fileName)) continue;

        memory_file_info new_info = {
            i, header, name, _dyld_get_image_vmaddr_slide(i)
        };

        _info = new_info;
    }
    return _info;
}


uint64_t KittyMemory::getAbsoluteAddress(const char *fileName, uint64_t address){
	memory_file_info info;
	if(fileName != NULL){
	   info = getMemoryFileInfo(fileName);
	} else {
	   info = getBaseInfo();
	}
    if(info.address == 0)
        return 0;
    return info.address + address;
}
//
//  KittyMemory.hpp
//
//
//  Created by MJ (Ruit) on 1/1/19.
//
//

#pragma once


#include <stdio.h>
#include <string>
#include <unistd.h>
#include <sys/mman.h>
#include <mach-o/dyld.h>
#include <mach/mach.h>
#include <libkern/OSCacheControl.h>
#include <vector>

#define BAD_KERN_CALL(call) call != KERN_SUCCESS

#define _SYS_PAGE_SIZE_ (sysconf(_SC_PAGE_SIZE))

#define _PAGE_START_OF_(x)    ((uintptr_t)x & ~(uintptr_t)(_SYS_PAGE_SIZE_ - 1))
#define _PAGE_END_OF_(x, len) (_PAGE_START_OF_((uintptr_t)x + len - 1))
#define _PAGE_LEN_OF_(x, len) (_PAGE_END_OF_(x, len) - _PAGE_START_OF_(x) + _SYS_PAGE_SIZE_)
#define _PAGE_OFFSET_OF_(x)   ((uintptr_t)x - _PAGE_START_OF_(x))

#define _PROT_RWX_ (PROT_READ | PROT_WRITE | PROT_EXEC)
#define _PROT_RX_  (PROT_READ | PROT_EXEC)
#define _PROT_RW_  (PROT_READ | PROT_WRITE)


#define EMPTY_VEC_OFFSET std::vector<int>()


namespace KittyMemory {

    typedef enum {
        FAILED = 0,
        SUCCESS = 1,
        INV_ADDR = 2,
        INV_LEN = 3,
        INV_BUF = 4,
        INV_PROT = 5,
        INV_KERN_CALL = 6,
        INV_MAP = 7
    } Memory_Status;


    typedef struct {
        int index;
        const mach_header *header;
        const char *name;
        intptr_t address;
    } memory_file_info;


    /*
     * Changes protection of an address with given length
     */
    bool ProtectAddr(void *address, size_t length, int protection, bool aligned);

    /*
     * Writes buffer content to an address
     */
    Memory_Status memWrite(void *address, const void *buffer, size_t len);

    /*
     * Reads an address content into a buffer
     */
    Memory_Status memRead(void *buffer, const void *addr, size_t len);

    /*
     * Wrapper to dereference & get value of a multi level pointer
     * Make sure to use the correct data type!
     */
    template<typename Type>
    Type readMultiPtr(void *ptr, std::vector<int> offsets) {
        Type defaultVal = {};
        if (ptr == NULL)
            return defaultVal;

        uintptr_t finalPtr = reinterpret_cast<uintptr_t>(ptr);
        int offsetsSize = offsets.size();
        if (offsetsSize > 0) {
            for (int i = 0; finalPtr != 0 && i < offsetsSize; i++) {
                if (i == (offsetsSize - 1))
                    return *reinterpret_cast<Type *>(finalPtr + offsets[i]);

                finalPtr = *reinterpret_cast<uintptr_t *>(finalPtr + offsets[i]);
            }
        }

        if (finalPtr == 0)
            return defaultVal;

        return *reinterpret_cast<Type *>(finalPtr);
    }


    /*
     * Wrapper to dereference & set value of a multi level pointer
     * Make sure to use the correct data type!, const objects won't work
     */
    template<typename Type>
    bool writeMultiPtr(void *ptr, std::vector<int> offsets, Type val) {
        if (ptr == NULL)
            return false;

        uintptr_t finalPtr = reinterpret_cast<uintptr_t>(ptr);
        int offsetsSize = offsets.size();
        if (offsetsSize > 0) {
            for (int i = 0; finalPtr != 0 && i < offsetsSize; i++) {
                if (i == (offsetsSize - 1)) {
                    *reinterpret_cast<Type *>(finalPtr + offsets[i]) = val;
                    return true;
                }

                finalPtr = *reinterpret_cast<uintptr_t *>(finalPtr + offsets[i]);
            }
        }

        if (finalPtr == 0)
            return false;

        *reinterpret_cast<Type *>(finalPtr) = val;
        return true;
    }


	/*
     * Wrapper to dereference & get value of a pointer
     * Make sure to use the correct data type!
     */
    template<typename Type>
    Type readPtr(void *ptr) {
        Type defaultVal = {};
        if (ptr == NULL)
            return defaultVal;

        return *reinterpret_cast<Type *>(ptr);
    }


	/*
     * Wrapper to dereference & set value of a pointer
     * Make sure to use the correct data type!, const objects won't work
     */
    template<typename Type>
    bool writePtr(void *ptr, Type val) {
        if (ptr == NULL)
            return false;

        *reinterpret_cast<Type *>(ptr) = val;
        return true;
    }


    /*
     * Reads an address content and returns hex string
     */
    std::string read2HexStr(const void *address, size_t len);


    kern_return_t getPageInfo(void *page_start, vm_region_submap_short_info_64 *outInfo);

    /*
    * returns base executable info
    */
    memory_file_info getBaseInfo();

    /*
    * find in memory file info
    */
    memory_file_info getMemoryFileInfo(const char *fileName);

    /*
    * returns relative address of file in memory, NULL as fileName will return base executable
    */
    uint64_t getAbsoluteAddress(const char *fileName, uint64_t address);

};
} #include "KittyUtils.hpp"

static void xtrim(std::string &hex){
    if(hex.compare(0, 2, "0x") == 0){
        hex.erase(0, 2);
    }

    // https://www.techiedelight.com/remove-whitespaces-string-cpp/
    hex.erase(std::remove_if(hex.begin(), hex.end(), [](char c){
								return (c == ' ' || c == '\n' || c == '\r' ||
										c == '\t' || c == '\v' || c == '\f');
							}),
							hex.end());
}


bool KittyUtils::validateHexString(std::string &xstr){
    if(xstr.length() < 2) return false;
    xtrim(xstr); // first remove spaces
    if(xstr.length() % 2 != 0) return false;
    for(size_t i = 0; i < xstr.length(); i++){
        if(!std::isxdigit((unsigned char)xstr[i])){
            return false;
        }
    }
    return true;
}


// https://tweex.net/post/c-anything-tofrom-a-hex-string/
#include <sstream>
#include <iomanip>


// ------------------------------------------------------------------
/*!
    Convert a block of data to a hex string
*/
void KittyUtils::toHex(
    void *const data,           //!< Data to convert
    const size_t dataLength,    //!< Length of the data to convert
    std::string &dest           //!< Destination string
    )
{
    unsigned char     *byteData = reinterpret_cast<unsigned char*>(data);
    std::stringstream hexStringStream;

    hexStringStream << std::hex << std::setfill('0');
    for(size_t index = 0; index < dataLength; ++index)
        hexStringStream << std::setw(2) << static_cast<int>(byteData[index]);
    dest = hexStringStream.str();
}


// ------------------------------------------------------------------
/*!
    Convert a hex string to a block of data
*/
void KittyUtils::fromHex(
    const std::string &in,     //!< Input hex string
    void *const data           //!< Data store
    )
{
    size_t          length    = in.length();
    unsigned char   *byteData = reinterpret_cast<unsigned char*>(data);

    std::stringstream hexStringStream; hexStringStream >> std::hex;
    for(size_t strIndex = 0, dataIndex = 0; strIndex < length; ++dataIndex)
    {
        // Read out and convert the string two characters at a time
        const char tmpStr[3] = { in[strIndex++], in[strIndex++], 0 };

        // Reset and fill the string stream
        hexStringStream.clear();
        hexStringStream.str(tmpStr);

        // Do the conversion
        int tmpValue = 0;
        hexStringStream >> tmpValue;
        byteData[dataIndex] = static_cast<unsigned char>(tmpValue);
    }
}
#pragma once

#include <string>
#include <algorithm>

namespace KittyUtils {

    bool validateHexString(std::string &xstr);
    void toHex(void *const data, const size_t dataLength, std::string &dest);
    void fromHex(const std::string &in, void *const data);

}#include <iostream>
#include <set>
using namespace std;

// Function to check if consecutive integers form an array
bool isConsecutive(int arr[], int n)
{
	// 1. Check if all elements in the array are distinct.

	// create an empty tree-based set
	set<int> set;

	// traverse the array and checks if each element appears only once
	for (int i = 0; i < n; i++)
	{
		// if an element is seen before, return false
		if (set.find(arr[i]) != set.end())
		{
			return false;
		}

		// mark element as seen
		set.insert(arr[i]);
	}

	// 2. Check if all elements present in the set are consecutive
	int prev;

	// iterate through the set and check if the difference between
	// consecutive elements is 1
	// (Note that `std::set` stores the elements in sorted order)
	for (int curr: set)
	{
		if (curr != *set.begin() && (curr != prev + 1))
		{
			return false;
		}

		prev = curr;
	}

	return true;
}

int main()
{
	int arr[] = { -1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 };
	int n = sizeof(arr) / sizeof(arr[0]);

	isConsecutive(arr, n) ? cout << "The array contains consecutive integers" :
		cout << "The array does not contain consecutive integers";

	return 0; //
//  MemoryBackup.cpp
//
//  Created by MJ (Ruit) on 4/19/20.
//

#include "MemoryBackup.hpp"


MemoryBackup::MemoryBackup() {
  _address = 0;
  _size    = 0;
  _orig_code.clear();
}

MemoryBackup::MemoryBackup(const char *fileName, uint64_t address, size_t backup_size) {
  MemoryBackup();

  if (address == 0 || backup_size < 1)
    return;

   _address = reinterpret_cast<void *>(KittyMemory::getAbsoluteAddress(fileName, address));
   if(_address == NULL) return;
  
  _size = backup_size;

  _orig_code.resize(backup_size);

  // backup current content
  KittyMemory::memRead(&_orig_code[0], reinterpret_cast<const void *>(_address), backup_size);
}


MemoryBackup::MemoryBackup(uint64_t absolute_address, size_t backup_size) {
  MemoryBackup();

  if (absolute_address == 0 || backup_size < 1)
    return;

   _address = reinterpret_cast<void *>(absolute_address);
  
  _size = backup_size;

  _orig_code.resize(backup_size);

  // backup current content
  KittyMemory::memRead(&_orig_code[0], reinterpret_cast<const void *>(_address), backup_size);
}

   MemoryBackup::~MemoryBackup() {
     // clean up
     _orig_code.clear();
   }


  bool MemoryBackup::isValid() const {
    return (_address != 0 && _size > 0
            && _orig_code.size() == _size);
  }

  size_t MemoryBackup::get_BackupSize() const{
    return _size;
  }

  void *MemoryBackup::get_TargetAddress() const{
    return _address;
  }

  bool MemoryBackup::Restore() {
    if (!isValid()) return false;
    return KittyMemory::memWrite(reinterpret_cast<void *>(_address), &_orig_code[0], _size) == KittyMemory::SUCCESS;
  }

  std::string MemoryBackup::get_CurrBytes() {
    if (!isValid()) 
      _hexString = std::string("0xInvalid");
      else 
      _hexString = KittyMemory::read2HexStr(reinterpret_cast<const void *>(_address), _size);

    return _hexString;
  }

}//
//  MemoryBackup.hpp
//
//  Created by MJ (Ruit) on 4/19/20.
//

#pragma once

#include <vector>

#include "KittyMemory.hpp"

class MemoryBackup {
private:
    void     *_address;
    size_t    _size;

    std::vector<uint8_t> _orig_code;

    std::string _hexString;

public:
    MemoryBackup();

    /*
     * expects library name and relative address
     */
    MemoryBackup(const char *fileName, uint64_t address, size_t backup_size);

    /*
     * expects absolute address
     */
    MemoryBackup(uint64_t absolute_address, size_t backup_size);


    ~MemoryBackup();


    /*
     * Validate patch
     */
    bool isValid() const;


    size_t get_BackupSize() const;

    /*
     * Returns pointer to the target address
     */
    void *get_TargetAddress() const;


    /*
     * Restores backup code
     */
    bool Restore();


    /*
     * Returns current target address bytes as hex string
     */
    std::string get_CurrBytes();
};
//
//  MemoryPatch.cpp
//
//  Created by MJ (Ruit) on 1/1/19.
//

#include "MemoryPatch.hpp"


MemoryPatch::MemoryPatch() {
  _address = 0;
  _size    = 0;
  _orig_code.clear();
  _patch_code.clear();
}

MemoryPatch::MemoryPatch(uint64_t absolute_address,
                         const void *patch_code, size_t patch_size) {
    MemoryPatch();

    if (absolute_address == 0 || patch_code == NULL || patch_size < 1)
        return;

    _address = reinterpret_cast<void *>(absolute_address);
    _size    = patch_size;

    _orig_code.resize(patch_size);
    _patch_code.resize(patch_size);

    // initialize patch & backup current content
    KittyMemory::memRead(&_patch_code[0], patch_code, patch_size);
    KittyMemory::memRead(&_orig_code[0], static_cast<const void *>(_address), patch_size);
}

MemoryPatch::MemoryPatch(const char *fileName, uint64_t address,
                         const void *patch_code, size_t patch_size) {
    MemoryPatch();

    if (address == 0 || patch_code == NULL || patch_size < 1)
        return;

    _address = reinterpret_cast<void *>(KittyMemory::getAbsoluteAddress(fileName, address));
    if(_address == NULL) return;

    _size = patch_size;

    _orig_code.resize(patch_size);
    _patch_code.resize(patch_size);

    // initialize patch & backup current content
    KittyMemory::memRead(&_patch_code[0], patch_code, patch_size);
    KittyMemory::memRead(&_orig_code[0], reinterpret_cast<const void *>(_address), patch_size);
}

   MemoryPatch::~MemoryPatch() {
     // clean up
     _orig_code.clear();
     _patch_code.clear();
   }


  MemoryPatch MemoryPatch::createWithHex(const char *fileName, uint64_t address, std::string hex) {
    MemoryPatch patch;

    if (address == 0 || !KittyUtils::validateHexString(hex))
        return patch;

    patch._address = reinterpret_cast<void *>(KittyMemory::getAbsoluteAddress(fileName, address));
    if(patch._address == NULL) return patch;

    patch._size = hex.length() / 2;

    patch._orig_code.resize(patch._size);
    patch._patch_code.resize(patch._size);

    // initialize patch
    KittyUtils::fromHex(hex, &patch._patch_code[0]);

    // backup current content
    KittyMemory::memRead(&patch._orig_code[0], reinterpret_cast<const void *>(patch._address), patch._size);
    return patch;
  }

  MemoryPatch MemoryPatch::createWithHex(uint64_t absolute_address, std::string hex) {
    MemoryPatch patch;

    if (absolute_address == 0 || !KittyUtils::validateHexString(hex))
      return patch;

    patch._address = reinterpret_cast<void *>(absolute_address);
    patch._size    = hex.length() / 2;

    patch._orig_code.resize(patch._size);
    patch._patch_code.resize(patch._size);

    // initialize patch
    KittyUtils::fromHex(hex, &patch._patch_code[0]);

    // backup current content
    KittyMemory::memRead(&patch._orig_code[0], reinterpret_cast<const void *>(patch._address), patch._size);
    return patch;
  }

  bool MemoryPatch::isValid() const {
    return (_address != NULL && _size > 0
            && _orig_code.size() == _size && _patch_code.size() == _size);
  }

  size_t MemoryPatch::get_PatchSize() const{
    return _size;
  }

  void *MemoryPatch::get_TargetAddress() const{
    return _address;
  }

  bool MemoryPatch::Restore() {
    if (!isValid()) return false;
    return KittyMemory::memWrite(_address, &_orig_code[0], _size) == KittyMemory::SUCCESS;
  }

  bool MemoryPatch::Modify() {
    if (!isValid()) return false;
    return (KittyMemory::memWrite(_address, &_patch_code[0], _size) ==  KittyMemory::SUCCESS);
  }

  std::string MemoryPatch::get_CurrBytes() {
    if (!isValid())
      _hexString = std::string("0xInvalid");
      else
      _hexString = KittyMemory::read2HexStr(reinterpret_cast<const void *>(_address), _size);

    return _hexString;
  }//
//  MemoryPatch.h
//
//  Created by MJ (Ruit) on 1/1/19.
//

#pragma once

#include <vector>

#include "KittyMemory.hpp"
#include "KittyUtils.hpp"


class MemoryPatch {
private:
    void     *_address;
    size_t    _size;

    std::vector<uint8_t> _orig_code;
    std::vector<uint8_t> _patch_code;

    std::string _hexString;

public:
    MemoryPatch();

    /*
     * expects an already calculated address
     */
    MemoryPatch(uint64_t absolute_address,
                             const void *patch_code, size_t patch_size);

    /*
     * expects file name and relative address, you can pass NULL as filename for base executable
     */
    MemoryPatch(const char *fileName, uint64_t address,
            const void *patch_code, size_t patch_size);


    ~MemoryPatch();

    /*
    * compatible hex format (0xffff & ffff & ff ff)
    */
    static MemoryPatch createWithHex(const char *fileName, uint64_t address, std::string hex);
    static MemoryPatch createWithHex(uint64_t absolute_address, std::string hex);

    /*
     * Validate patch
     */
    bool isValid() const;


    size_t get_PatchSize() const;

    /*
     * Returns pointer to the target address
     */
    void *get_TargetAddress() const;


    /*
     * Restores patch to original value
     */
    bool Restore();


    /*
     * Applies patch modifications to target address
     */
    bool Modify();


    /*
     * Returns current patch target address bytes as hex string
     */
    std::string get_CurrBytes();
};KittyMemory is NOT made by me, it's made by Ruit.

I just implemented it in my menu.

KittyMemory is open source & can be found on github:
- https://github.com/MJx0/KittyMemory
//
//  writeData.cpp
//
//
//  Created by MJ (Ruit) on 4/13/19.
//


/*
   This is an alternative for the old writeData that was made by HackJack & Razzile
*/

#include "writeData.hpp"



bool writeData8(uint64_t offset, uint8_t data)
{
	const size_t sz = sizeof(uint8_t);

	 // pass NULL as fileName for base executable
  return MemoryPatch(NULL, /* relative address */ offset, /* patch bytes */ &data, /* patch bytes length */ sz).Modify();
}

bool writeData16(uint64_t offset, uint16_t data)
{
	const size_t sz = sizeof(uint16_t);
	SwapData<uint16_t>(data);

	 // pass NULL as fileName for base executable
  return MemoryPatch(NULL, /* relative address */ offset, /* patch bytes */ &data, /* patch bytes length */ sz).Modify();
}

bool writeData32(uint64_t offset, uint32_t data)
{
	const size_t sz = sizeof(uint32_t);
	SwapData<uint32_t>(data);

	 // pass NULL as fileName for base executable
  return MemoryPatch(NULL, /* relative address */ offset, /* patch bytes */ &data, /* patch bytes length */ sz).Modify();
}


bool writeData64(uint64_t offset, uint64_t data)
{
	const size_t sz = sizeof(uint64_t);
	SwapData<uint64_t>(data);

	 // pass NULL as fileName for base executable
  return MemoryPatch(NULL, /* relative address */ offset, /* patch bytes */ &data, /* patch bytes length */ sz).Modify();
}
//
//  writeData.h
//
//
//  Created by MJ (Ruit) on 4/13/19.
//


/* 
   This is an alternative for the old writeData that was made by HackJack & Razzile 
*/


#ifndef writeData_h
#define writeData_h

#include <math.h>
#include "MemoryPatch.hpp"


#define BITS_IN_BYTE 8


// https://www.exploringbinary.com/number-of-bits-in-a-decimal-integer/
// returns bits size of an integer
inline int findBits(uint64_t n) 
{ 
   if(n > 0)
   {
	   return floor(log(n)/log(2))+1;
   }
   return 0;
} 


// returns bytes size of an integer
inline size_t findBytes(uint64_t data) 
{ 
   int bits = findBits(data);
   if(bits > 0)
   {
	   return (size_t)(bits / BITS_IN_BYTE);
   }
   return 0;
} 


template<typename T>
void SwapData(T& data) 
{
	const size_t sz = sizeof(T);
	switch (sz) 
	{
	   case sizeof(int16_t):
	       data = _OSSwapInt16(data);
	       break;
	   case sizeof(int32_t):
	       data = _OSSwapInt32(data);
	       break;
	   case sizeof(int64_t):
	       data = _OSSwapInt64(data);
	       break;
	   default:
	       break;
	}
}

bool writeData8 (uint64_t offset, uint8_t  data);
bool writeData16(uint64_t offset, uint16_t data);
bool writeData32(uint64_t offset, uint32_t data);
bool writeData64(uint64_t offset, uint64_t data);

#endif /* writeData.h */
