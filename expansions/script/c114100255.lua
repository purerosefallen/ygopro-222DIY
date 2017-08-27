--★小人（ホムンクルス）の片割れ グリード
function c114100255.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon method2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c114100255.xyzcon)
	e2:SetOperation(c114100255.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	--destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c114100255.reptg)
    c:RegisterEffect(e3)
	--attack up
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMING_BATTLE_PHASE)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c114100255.adcost)
	e4:SetOperation(c114100255.adop)
	c:RegisterEffect(e4)
end

function c114100255.xyzfilter(c)
	return c:IsSetCard(0x221) and ( ( c:IsFaceup() and not c:IsType(TYPE_TOKEN) ) or not c:IsLocation(LOCATION_MZONE) )
end
function c114100255.xyzcon(e,c,og)
	if c==nil then return true end
	local abcount=0
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>=-1 then 
		local chkct=true
		local lvb=c114100255.lvchk(c:GetControler())
		local mct=0 -- count suitable monsters
		local j=0
			for i=1,lvb do
				j=0
				chkct=true
				repeat
					if Duel.CheckXyzMaterial(c,c114100255.xyzfilter,i,j+1,j+1,og) then
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

function c114100255.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if og then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg
		local sel=e:GetLabel()
		if sel==3 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(114100255,2))
			sel=Duel.SelectOption(tp,aux.Stringid(114100255,0),aux.Stringid(114100255,1))+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		if sel==2 then
			local ag=Duel.GetMatchingGroup(c114100255.xyzfilter,tp,LOCATION_MZONE,0,nil)
			local pg=Group.CreateGroup()
			local chkpg=false
			local agtg=ag:GetFirst()
			local lvb=c114100255.lvchk(tp)
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
function c114100255.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	return true
end

--atk up
function c114100255.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and e:GetHandler():GetFlagEffect(114100255)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c114100255.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		--e1:SetCode(EFFECT_UPDATE_ATTACK)
		--e1:SetValue(1500)
		--e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		--c:RegisterEffect(e1)
		--local e2=e1:Clone()
		--e2:SetCode(EFFECT_UPDATE_DEFENSE)
		--c:RegisterEffect(e2)
		c:RegisterFlagEffect(114100255,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetCondition(c114100255.atkcon)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c114100255.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end

--definition
function c114100255.xyzdef(c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,114100255)
	local mgtg=mg:GetFirst()
	if mgtg then
		local jud=false
		local lvb=c114100255.lvchk(tp)
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
function c114100255.lvchk(tp)
	local lv=13
	local lvmg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if lvmg:GetCount()>0 then
		local lvc=lvmg:GetMaxGroup(Card.GetLevel):GetFirst():GetLevel()
		if lvc>lv then lv=lvc end
	end
	return lv
end
c114100255.xyz_filter=c114100255.xyzdef
c114100255.xyz_count=2
--end of definition