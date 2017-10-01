--AIW·碎境的娃娃商人4
function c66619921.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c66619921.xyzcon)
	e1:SetTarget(c66619921.xyztg)
	e1:SetOperation(c66619921.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66619921,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c66619921.target)
	e2:SetOperation(c66619921.operation)
	c:RegisterEffect(e2)
	--naka
	local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(66619921,5))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c66619921.regcon)
	e3:SetTarget(c66619921.target1)
	e3:SetOperation(c66619921.operation1)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c66619921.value)
	c:RegisterEffect(e4)
end
function c66619921.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCode(66619911) and c:IsCanBeXyzMaterial(xyzc)
		and c:CheckRemoveOverlayCard(tp,3,REASON_COST) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
end
function c66619921.mfilter(c)
	return c:IsType(TYPE_SYNCHRO) 
end
function c66619921.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCountFromEx(tp)
	local ct=-ft
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	if (not min or min<=1) and mg:IsExists(c66619921.ovfilter,1,nil,tp,c) then
		return true
	end
	local minc=2
	local maxc=63
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	return ct<minc and Duel.CheckXyzMaterial(c,c66619921.mfilter,6,minc,maxc,og)
end
function c66619921.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then
		return true
	end
	local ft=Duel.GetLocationCountFromEx(tp)
	local ct=-ft
	local minc=2
	local maxc=63
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	end
	local b1=ct<minc and Duel.CheckXyzMaterial(c,c66619921.mfilter,6,minc,maxc,og)
	local b2=(not min or min<=1) and mg:IsExists(c66619921.ovfilter,1,nil,tp,c)
	local g=nil
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(66619921,1))) then
		e:SetLabel(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c66619921.ovfilter,1,1,nil,tp,c)
		g:GetFirst():RemoveOverlayCard(tp,3,3,REASON_COST)
	else
		e:SetLabel(0)
		g=Duel.SelectXyzMaterial(tp,c,c66619921.mfilter,6,minc,maxc,og)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c66619921.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		if e:GetLabel()==1 then
			local mg2=mg:GetFirst():GetOverlayGroup()
			if mg2:GetCount()~=0 then
				Duel.Overlay(c,mg2)
			end
		end
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
	if e:GetLabel()==1 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_ATTACK)
		e5:SetValue(0)
		e5:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_SET_DEFENSE)
		e6:SetValue(0)
		c:RegisterEffect(e6)
	end
end
function c66619921.cfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x666) and c:GetLevel()==6
end
function c66619921.bfilter(c)
	return c:IsCode(66619916)
end
function c66619921.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c66619921.bfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingTarget(c66619921.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c66619921.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local code=g1:GetFirst():GetCode()
	e:SetLabel(code)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c66619921.bfilter,tp,LOCATION_SZONE,0,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c66619921.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=e:GetLabel()
	if sg==66619907 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(66619921,2))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c66619921.disop)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_BATTLE_START)
		e2:SetTarget(c66619921.destg)
		e2:SetOperation(c66619921.desop)
		e2:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e2)
	elseif sg==66619909 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(66619921,3))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x666))
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
	elseif sg==66619908 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(66619921,4))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetTarget(c66619921.trtg)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
	elseif sg==66619920 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(66619921,5))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c66619921.condition1)
		e1:SetOperation(c66619921.activate)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
	end
end
function c66619921.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
function c66619921.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c66619921.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end
function c66619921.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c66619921.tfilter(c)
	return c:GetOriginalCode()==66619919
end
function c66619921.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetOverlayCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c66619921.tfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c66619921.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetOverlayCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66619921.tfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66619921.trtg(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c66619921.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:GetHandler():IsOnField() and ((re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP)) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c66619921.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) then
		local sel=1
		local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_SPELL)
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(66619921,6))
		if g:GetCount()>0 then
			sel=Duel.SelectOption(1-tp,1213,1214)
		else
			sel=Duel.SelectOption(1-tp,1214)+1
		end
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
			Duel.NegateEffect(0)
			return
		end
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c66619921.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c66619921.value(e,c)
	return Duel.GetMatchingGroupCount(c66619921.filter2,0,LOCATION_SZONE,0,nil)*500
end