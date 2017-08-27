--★投射された心の闇
function c114100029.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetDescription(aux.Stringid(114100029,1))
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114100029.xyzcon)
	e2:SetOperation(c114100029.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetCondition(c114100029.limcon)
	c:RegisterEffect(e3)
	if not c114100029.global_check then
		c114100029.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c114100029.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c114100029.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsCode(114100029) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,114100029,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,114100029,RESET_PHASE+PHASE_END,0,1) end
end
function c114100029.limcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),114100029)~=0
end

--sp summon method2
function c114100029.xyzfilter(c,slf)
	return c:IsSetCard(0x221)
	and c:IsType(TYPE_MONSTER)
	and c:IsCanBeXyzMaterial(slf,true)
end
function c114100029.xyzcon(e,c,og)
	if c==nil then return true end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local abcount=0
	if ft>0 and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)>0 and Duel.IsExistingMatchingCard(c114100029.xyzfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil,c) then abcount=abcount+2 end
	if ft>=-1 then if Duel.CheckXyzMaterial(c,nil,3,2,2,og) then abcount=abcount+1 end end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end

function c114100029.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114100029,2))
			sel=Duel.SelectOption(tp,aux.Stringid(114100029,0),aux.Stringid(114100029,1))+1
		end
		local mg
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if sel==2 then
			mg=Duel.SelectMatchingCard(tp,c114100029.xyzfilter,tp,LOCATION_GRAVE,0,1,1,nil,c)
		else
			mg=Duel.SelectXyzMaterial(tp,c,nil,3,2,2)
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		if sel==2 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end



--definition
function c114100029.xyzdef(c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114100029)
	local mgtg=mg:GetFirst()
	if mgtg then
		return c:IsXyzLevel(mgtg,3)
	else
		return c:GetLevel()==3
	end
end
c114100029.xyz_filter=c114100029.xyzdef
c114100029.xyz_count=2
--end of definition