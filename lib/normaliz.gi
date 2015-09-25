##
InstallMethod( ViewString,
               "for a Normaliz cone",
               [ IsNormalizLongIntCone ],
function( r )
    # TODO: May print more information when present
    return "<a Normaliz cone with long int coefficients>";
end );

InstallMethod( ViewString,
               "for a Normaliz cone",
               [ IsNormalizGMPCone ],
function( r )
    # TODO: May print more information when present
    return "<a Normaliz cone with GMP coefficients>";
end );

InstallMethod( NmzConeProperty,
               "for a Normaliz cone and a string",
               [ IsNormalizCone, IsString ],
function( cone, prop )
    local result, t, shift, poly, tmp, denom;
    result := _NmzConeProperty(cone, prop);
    if prop = "Grading" then
        denom := Remove(result);
        return result / denom;
    fi;
    if prop = "HilbertSeries" then
        t := Indeterminate(Integers, "t");
        poly := UnivariatePolynomial(Integers, result[1], t);
        shift := result[3];
        if shift > 0 then
            poly := poly * t^shift;
        fi;
        if shift < 0 then
            poly := poly / t^(-shift);
        fi;
        tmp := Collected(result[2]);
        return [poly, tmp];
    fi;
    if prop = "HilbertFunction" then
        t := Indeterminate(Rationals, "t");
        denom := Remove(result);
        poly := List(result, coeffs -> UnivariatePolynomial(Rationals, coeffs, t));
        return poly / denom;
    fi;
    return result;
end );

InstallGlobalFunction("NmzPrintConeProperties", function(cone)
    local prop, val;
    if not IsNormalizCone(cone) then
        Error("First argument must be a Normaliz cone object");
        return;
    fi;
    for prop in NmzKnownConeProperties(cone) do
        val := NmzConeProperty(cone, prop);
        Print(prop," = ");
        if IsMatrix(val) then
            Print("\n");
        fi;
        Display(val);
    od;
end);


InstallMethod( NmzBasisChange,
               "for a Normaliz cone",
               [ IsNormalizCone ],
function( cone )
    local result;
    result := _NmzBasisChange(cone);
    return rec(
        dim := result[1],
        rank := result[2],
        index := result[3],
        A := result[4],
        B := result[5],
        c := result[6],
        );
end );


#
#
#
InstallGlobalFunction("NmzCone", function(arg)
    local func, opts_rec, opts_list, cone;
    opts_rec := rec(
        gmp := ValueOption("gmp"),
    );
    if Length(arg) = 1 then
        if IsList(arg[1]) then
            opts_list := arg[1];
        #elif IsRecord(arg[1]) then
        #   TODO
        else
            # TODO: better error message
            Error("Unsupported input");
        fi;
    else
        opts_list := arg;
    fi;
    
    if opts_rec.gmp = true then
        cone := NmzGMPCone(opts_list);
    else
        cone := NmzLongIntCone(opts_list);
    fi;
    return cone;
end);

# TODO: extend NmzCone to allow this syntax:
##cone := NmzCone(rec(integral_closure := M, grading := [ 0, 0, 1 ]));;



#
#
#
InstallGlobalFunction("NmzCompute", function(arg)
    local cone, propsToCompute;
    if not Length(arg) in [1,2] then
        Error("Wrong number of arguments, expected 1 or 2");
        return fail;
    fi;
    cone := arg[1];
    if not IsNormalizCone(cone) then
        Error("First argument must be a Normaliz cone object");
        return fail;
    fi;
    if Length(arg) = 1 then
        propsToCompute := [];
        if ValueOption("dual") = true then Add(propsToCompute, "DualMode"); fi;
        if ValueOption("DualMode") = true then Add(propsToCompute, "DualMode"); fi;
        if ValueOption("HilbertBasis") = true then Add(propsToCompute, "HilbertBasis"); fi;
        # TODO: add more option names? or just support arbitrary ones, by using
        # iterating over the (undocumented!) OptionsStack???
        if Length(propsToCompute) = 0 then
            propsToCompute := [ "DefaultMode" ];
        fi;
    else
        if IsString(arg[2]) then
            propsToCompute := [arg[2]];
        else
            propsToCompute := arg[2];
        fi;
    fi;
    return _NmzCompute(cone, propsToCompute);
end);
