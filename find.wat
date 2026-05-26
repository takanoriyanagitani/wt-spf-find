(module

  (memory (export "memory") 2)

  (func $find_spf (export "find_spf")
    (param $sptr i32)
    (param $eptr i32)
    (result i32)

    ;; input $sptr: the pointer to the start of the string(haystack)
    ;; input $eptr: the pointer to the end of the string
    ;; result:
    ;;   - if found: the pointer to the first "spf="
    ;;   - if missing: -1
    ;; assumption: comments already removed, input fits in a page
    ;; example:
    ;;   input: ares.example.com; spf=pass
    ;;          0123456789abcdef0123456789
    ;;          ^                 ^      ^
    ;;          sptr              |      eptr
    ;;                            found!
    ;;   output: 0x0000_0012

    (local $icur i32)

    local.get $sptr
    local.set $icur

    loop
      ;; return -1 if not found
      local.get $eptr
      local.get $icur
      i32.lt_u
      if
        i32.const -1
        return
      end

      ;; load the 1st 4 bytes; e.g., 0,1,2,3
      local.get $icur
      i32.load offset=0
      i32.const 0x3d667073
      i32.eq
      if
        local.get $icur
        return
      end

      ;; load the 2nd 4 bytes; e.g., 1,2,3,4
      local.get $icur
      i32.load offset=1
      i32.const 0x3d667073
      i32.eq
      if
        local.get $icur
        i32.const 1
        i32.add
        return
      end

      ;; load the 3rd 4 bytes; e.g., 2,3,4,5
      local.get $icur
      i32.load offset=2
      i32.const 0x3d667073
      i32.eq
      if
        local.get $icur
        i32.const 2
        i32.add
        return
      end

      ;; load the 4th 4 bytes; e.g., 3,4,5,6
      local.get $icur
      i32.load offset=3
      i32.const 0x3d667073
      i32.eq
      if
        local.get $icur
        i32.const 3
        i32.add
        return
      end

      ;; process next
      local.get $icur
      i32.const 4
      i32.add
      local.set $icur

      br 0

    end

    i32.const -1
  )

)
