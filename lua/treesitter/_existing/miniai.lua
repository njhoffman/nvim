-- stylua: ignore
local miniai_customobj = {
    A = 'function 1',
    C = 'function 2',
    b = { { "%b()", "%b[]", "%b{}" }, "^.%s*().-()%s*.$" },
    c = 'function 3',
    e = 'function 4',
    f = 'function 5',
    l = 'function 6',
    o = 'function 7',
    t = { "'([%p%w]-)%f[^'%w][^'']-'.-'/%1'", "^'.-'().*()'/[^/]-'$" },
    x = 'function 8',
    ["|"] = { "|().-()|" }
}

-- n   *+   [iN       jump to left edge of i `prev` text object
-- n   *+   [in       jump to left edge of i `next` text object
-- n   *+   [aN       jump to left edge of a `prev` text object
-- n   *+   [an       jump to left edge of a `next` text object
-- v   *+   [iN       jump to left edge of i `prev` text object
-- v   *+   [in       jump to left edge of i `next` text object
-- v   *+   [aN       jump to left edge of a `prev` text object
-- v   *+   [an       jump to left edge of a `next` text object
-- n   *+   ]iN       jump to right edge of i `prev` text object
-- n   *+   ]in       jump to right edge of i `next` text object
-- n   *+   ]aN       jump to right edge of a `prev` text object
-- n   *+   ]an       jump to right edge of a `next` text object
-- v   *+   ]iN       jump to right edge of i `prev` text object
-- v   *+   ]in       jump to right edge of i `next` text object
-- v   *+   ]aN       jump to right edge of a `prev` text object
-- v   *+   ]an       jump to right edge of a `next` text object
