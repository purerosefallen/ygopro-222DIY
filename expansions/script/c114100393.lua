--★小人（ホムンクルス）の片割れ グラトニー
function c114100393.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114100393.xyzcon)
	e2:SetOperation(c114100393.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c114100393.reptg)
    c:RegisterEffect(e3)
	--redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	--remove2
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c114100393.rmcon)
	e5:SetTarget(c114100393.rmtg)
	e5:SetOperation(c114100393.rmop)
	c:RegisterEffect(e5)
end
function c114100393.xyzfilter(c)
	return c:IsSetCard(0x221) and ( ( c:IsFaceup() and not c:IsType(TYPE_TOKEN) ) or not c:IsLocation(LOCATION_MZONE) )
end
function c114100393.xyzcon(e,c,og)
	if c==nil then return true end
	local abcount=0
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=-1 then 
		local chkct=true
		local lvb=c114100393.lvchk(c:GetControler())
		local mct=0 -- count suitable monsters
		local j=0
			for i=1,lvb do
				j=0
				chkct=true
				repeat
					if Duel.CheckXyzMaterial(c,c114100393.xyzfilter,i,j+1,j+1,og) then
						j=j+1
					else
						chkct=false
					end
				until not chkct
				mct=mct+j
				if mct>=2 then break end
			end
		if mct>=2 then abcount=abcount+2 end
	end
	--if 2<=ct then return false end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=-2 then
		if Duel.CheckXyzMaterial(c,nil,4,3,3,og) then abcount=abcount+1 end 
	end
	if abcount>0 then
		e:SetLabel(abcount)
		return true
	else
		return false
	end
end

function c114100393.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114100393,2))
			sel=Duel.SelectOption(tp,aux.Stringid(114100393,0),aux.Stringid(114100393,1))+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if sel==2 then
			local ag=Duel.GetMatchingGroup(c114100393.xyzfilter,tp,LOCATION_MZONE,0,nil)
			local pg=Group.CreateGroup()
			local chkpg=false
			local agtg=ag:GetFirst()
			local lvb=c114100393.lvchk(tp)
			while agtg do
				chkpg=false
				for i=1,lvb do
					if Duel.CheckXyzMaterial(c,nil,i,1,1,Group.FromCards(agtg)) then pg:AddCard(agtg) chkpg=true end
					if chkpg then break end
				end
				agtg=ag:GetNext()
			end
			mg=pg:Select(tp,2,pg:GetCount(),nil)
		else
			mg=Duel.SelectXyzMaterial(tp,c,nil,4,3,3)
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
	end
end
--
function c114100393.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end
--remove2
function c114100393.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c114100393.homo,tp,LOCATION_GRAVE,0,1,nil)
end
function c114100393.homo(c)
	return c:IsSetCard(0x226) or c:IsCode(40410110) or c:IsCode(27408609)
end
function c114100393.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
end
function c114100393.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local seq=g:GetFirst():GetSequence()
		local ctp=g:GetFirst():GetControler()
		local rg=Group.CreateGroup()
		if seq>=0 and seq<5 then
			local c1=Duel.GetFieldCard(ctp,LOCATION_MZONE,seq)
			local c2=Duel.GetFieldCard(ctp,LOCATION_SZONE,seq)
			local c3=Duel.GetFieldCard(1-ctp,LOCATION_MZONE,4-seq)
			local c4=Duel.GetFieldCard(1-ctp,LOCATION_SZONE,4-seq)	
			if c1 and c1~=e:GetHandler() then rg:AddCard(c1) end
			if c2 and c2~=e:GetHandler() then rg:AddCard(c2) end
			if c3 and c3~=e:GetHandler() then rg:AddCard(c3) end
			if c4 and c4~=e:GetHandler() then rg:AddCard(c4) end
		else 
			if seq==6 or seq==7 then
				local c1=Duel.GetFieldCard(ctp,LOCATION_SZONE,seq)
				local c2=Duel.GetFieldCard(1-ctp,LOCATION_SZONE,13-seq)
				if c1 and c1~=e:GetHandler() then rg:AddCard(c1) end
				if c2 and c2~=e:GetHandler() then rg:AddCard(c2) end
			else
				if g:GetFirst()~=e:GetHandler() then rg:AddCard(g:GetFirst()) end
			end
		end
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end





--definition
function c114100393.xyzdef(c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114100393)
	local mgtg=mg:GetFirst()
	if mgtg then
		local jud=false
		local lvb=c114100393.lvchk(tp)
		for i=1,lvb do
			if i==4 then 
				if c:IsXyzLevel(mgtg,i) then jud=true end
			else
				if c:IsXyzLevel(mgtg,i) and c:IsSetCard(0x221) then jud=true end
			end
			if jud then break end
		end
		return jud
	else
		return c:GetLevel()==4 or ( c:IsSetCard(0x221) and not c:IsType(TYPE_XYZ) )
	end
end
function c114100393.lvchk(tp)
	local lv=13
	local lvmg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if lvmg:GetCount()>0 then
		local lvc=lvmg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		if lvc>lv then lv=lvc end
	end
	return lv
end
c114100393.xyz_filter=c114100393.xyzdef
c114100393.xyz_count=2
--end of definition