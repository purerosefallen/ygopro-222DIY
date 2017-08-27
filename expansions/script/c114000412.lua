--★不死の軍団（マネキン・ソルジャー）
function c114000412.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c114000412.xyzcon)
	e1:SetOperation(c114000412.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--xyz summon method2
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_SPSUMMON_PROC)
	--e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	--e2:SetDescription(aux.Stringid(114000412,1))
	--e2:SetRange(LOCATION_EXTRA)
	--e2:SetCondition(c114000412.xyzcon)
	--e2:SetOperation(c114000412.xyzop)
	--e2:SetValue(SUMMON_TYPE_XYZ)
	--c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c114000412.reptg)
	c:RegisterEffect(e3)
end
--sp summon method 1
--function c114000412.xyzfil(c)
--	return c:IsFaceup() --and c:GetLevel()==4 
--end
--sp summom method 2
--function c114000412.xyzfilter2q(c,slf)
--	return c:IsSetCard(0x221)
--	and c:GetLevel()>0 
--	and c:IsFaceup()
--	and c:IsCanBeXyzMaterial(slf,false)
--	and not c:IsType(TYPE_TOKEN)	
--	--Duel.IsExistingMatchingCard
--	--(c114000412.xyzfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c)
--end
function c114000412.xyzfilter(c)
	return c:IsSetCard(0x221) and ( ( c:IsFaceup() and not c:IsType(TYPE_TOKEN) ) or not c:IsLocation(LOCATION_MZONE) )
end
function c114000412.xyzcon(e,c,og)
	if c==nil then return true end
	local abcount=0
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=0 and Duel.GetFlagEffect(tp,114000412)==0 then 
		local check=false
		local lvb=c114000412.lvchk(c:GetControler())
		for i=1,lvb do
			if Duel.CheckXyzMaterial(c,c114000412.xyzfilter,i,1,1,og) then
				check=true
			end
			if check then break end
		end
		if check then abcount=abcount+2 end
	end
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local ct=-ft
	--if 2<=ct then return false end
	if ct<2 then if Duel.CheckXyzMaterial(c,nil,2,2,2,og) then abcount=abcount+1 end end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end

function c114000412.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114000412,2))
			sel=Duel.SelectOption(tp,aux.Stringid(114000412,0),aux.Stringid(114000412,1))+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if sel==2 then
			Duel.RegisterFlagEffect(tp,114000412,RESET_PHASE+PHASE_END,0,1)
			local ag=Duel.GetMatchingGroup(c114000412.xyzfilter,tp,LOCATION_MZONE,0,nil)
			local pg=Group.CreateGroup()
			local chkpg=false
			local agtg=ag:GetFirst()
			local lvb=c114000412.lvchk(tp)
			while agtg do
				chkpg=false
				for i=1,lvb do
					if Duel.CheckXyzMaterial(c,nil,i,1,1,Group.FromCards(agtg)) then pg:AddCard(agtg) chkpg=true end
					if chkpg then break end
				end
				agtg=ag:GetNext()
			end
			mg=pg:Select(tp,1,1,nil)
		else
			mg=Duel.SelectXyzMaterial(tp,c,nil,2,2,2)
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
	end
end

--destroy replace
function c114000412.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	local c=e:GetHandler()
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end
--definition
function c114000412.xyzdef(c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114000412)
	local mgtg=mg:GetFirst()
	if mgtg then
		local jud=false
		local lvb=c114000412.lvchk(tp)
		for i=1,lvb do
			if i==2 then 
				if c:IsXyzLevel(mgtg,i) then jud=true end
			else
				if c:IsXyzLevel(mgtg,i) and c:IsSetCard(0x221) then jud=true end
			end
			if jud then break end
		end
		return jud
	else
		return c:GetLevel()==2 or ( c:IsSetCard(0x221) and not c:IsType(TYPE_XYZ) )
	end
end

function c114000412.lvchk(tp)
	local lv=13
	local lvmg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if lvmg:GetCount()>0 then
		local lvc=lvmg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		if lvc>lv then lv=lvc end
	end
	return lv
end

c114000412.xyz_filter=c114000412.xyzdef
c114000412.xyz_count=2
--end of defintion
