#include <emmintrin.h>
#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "simd.h"

long long int sum(int vals[NUM_ELEMS]) {
	clock_t start = clock();

	long long int sum = 0;
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS; i++) {
			if(vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	long long int sum = 0;

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
			if(vals[i] >= 128) sum += vals[i];
			if(vals[i + 1] >= 128) sum += vals[i + 1];
			if(vals[i + 2] >= 128) sum += vals[i + 2];
			if(vals[i + 3] >= 128) sum += vals[i + 3];
		}

		//This is what we call the TAIL CASE
		//For when NUM_ELEMS isn't a multiple of 4
		//NONTRIVIAL FACT: NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
		for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);		// This is a vector with 127s in it... Why might you need this?
	long long int result = 0;				   // This is where you should put your final result!
	/* DO NOT DO NOT DO NOT DO NOT WRITE ANYTHING ABOVE THIS LINE. */
	
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		/* YOUR CODE GOES HERE */
		__m128i loop_sum = _mm_setzero_si128();
		for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
			/* load four 32bit element from vals into v */
			__m128i four_int = _mm_loadu_si128(&vals[i]);
			__m128i compare = _mm_cmpgt_epi32(four_int, _127); // bigger than 127?
			four_int = _mm_and_si128(four_int, compare);
			loop_sum = _mm_add_epi32(loop_sum, four_int);
		}
		
		int temp[4] = {0, 0, 0, 0};
		_mm_storeu_si128(temp, loop_sum);
		for (int i = 0; i < 4; i += 1) {
			result += temp[i];
		}
			/* You'll need a tail case. */
	
		for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				result += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}

long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);
	long long int result = 0;
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		/* COPY AND PASTE YOUR sum_simd() HERE */
		/* MODIFY IT BY UNROLLING IT */
		__m128i loop_sum = _mm_setzero_si128();
		for(unsigned int i = 0; i < NUM_ELEMS / 16 * 16; i += 16) {               	
			/* You'll need 1 or maybe 2 tail cases here. */
			/* load four 32bit element from vals into v */
			__m128i v1 = _mm_loadu_si128(&vals[i]);
			__m128i v2 = _mm_loadu_si128(&vals[i+4]);
			__m128i v3 = _mm_loadu_si128(&vals[i+8]);
			__m128i v4 = _mm_loadu_si128(&vals[i+12]);
			__m128i c1 = _mm_cmpgt_epi32(v1, _127); // bigger than 127?	
			__m128i c2 = _mm_cmpgt_epi32(v2, _127); // bigger than 127?
			__m128i c3 = _mm_cmpgt_epi32(v3, _127); // bigger than 127?
		        __m128i c4 = _mm_cmpgt_epi32(v4, _127); // bigger than 127?
		        v1 = _mm_and_si128(v1, c1);
		        v2 = _mm_and_si128(v2, c2);
		        v3 = _mm_and_si128(v3, c3);
		        v4 = _mm_and_si128(v4, c4);
			loop_sum = _mm_add_epi32(loop_sum, v1); 
			loop_sum = _mm_add_epi32(loop_sum, v2);
			loop_sum = _mm_add_epi32(loop_sum, v3);
			loop_sum = _mm_add_epi32(loop_sum, v4);
		} 
		
		int temp[4] = {0, 0, 0, 0};
		_mm_storeu_si128(temp, loop_sum);
		for (int i = 0; i < 4; i += 1) {
			result += temp[i];
		}
			/* You'll need a tail case. */
	
		for(unsigned int i = NUM_ELEMS / 16 * 16; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				result += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}
