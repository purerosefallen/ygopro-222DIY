--★小人（ホムンクルス）の片割れ エンヴィー
function c114001037.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114001037.xyzcon)
	e2:SetOperation(c114001037.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c114001037.reptg)
    c:RegisterEffect(e3)
	--atkup
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(c114001037.adval)
    c:RegisterEffect(e4)
	--atkup
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetCondition(c114001037.atkcon)
    e5:SetValue(0)
    c:RegisterEffect(e5)
	--material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetCondition(c114001037.descon)
	--e6:SetTarget(c114001037.target)
	e6:SetOperation(c114001037.operation)
	c:RegisterEffect(e6)
end
--
function c114001037.xyzfilter(c)
	return c:IsSetCard(0x221) and ( ( c:IsFaceup() and not c:IsType(TYPE_TOKEN) ) or not c:IsLocation(LOCATION_MZONE) )
end
function c114001037.xyzcon(e,c,og)
	if c==nil then return true end
	local abcount=0
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=-1 then 
		local chkct=true
		local lvb=c114001037.lvchk(c:GetControler())
		local mct=0 -- count suitable monsters
		local j=0
			for i=1,lvb do
				j=0
				chkct=true
				repeat
					if Duel.CheckXyzMaterial(c,c114001037.xyzfilter,i,j+1,j+1,og) then
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

function c114001037.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114001037,2))
			sel=Duel.SelectOption(tp,aux.Stringid(114001037,0),aux.Stringid(114001037,1))+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if sel==2 then
			local ag=Duel.GetMatchingGroup(c114001037.xyzfilter,tp,LOCATION_MZONE,0,nil)
			local pg=Group.CreateGroup()
			local chkpg=false
			local agtg=ag:GetFirst()
			local lvb=c114001037.lvchk(tp)
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
function c114001037.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end
--atkup
function c114001037.adval(e,c)
	return c:GetOverlayCount()*200
end
function c114001037.atkcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
--material
function c114001037.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetSummonLocation()==LOCATION_EXTRA and not bc:IsType(TYPE_TOKEN) and bc:IsAbleToChangeControler() and c:IsType(TYPE_XYZ) and not bc:IsSetCard(0x226) 
end
function c114001037.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end



--definition
function c114001037.xyzdef(c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114001037)
	local mgtg=mg:GetFirst()
	if mgtg then
		local jud=false
		local lvb=c114001037.lvchk(tp)
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
function c114001037.lvchk(tp)
	local lv=13
	local lvmg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if lvmg:GetCount()>0 then
		local lvc=lvmg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		if lvc>lv then lv=lvc end
	end
	return lv
end
c114001037.xyz_filter=c114001037.xyzdef
c114001037.xyz_count=2
--end of definition