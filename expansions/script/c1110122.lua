--灵都圣芒·苜
function c1110122.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c1110122.xyzfilter,3,2,c1110122.ovfilter,aux.Stringid(1110122,0),2,c1110122.xyzop)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110122,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1110122)
	e2:SetCost(c1110122.cost2)
	e2:SetTarget(c1110122.tg2)
	e2:SetOperation(c1110122.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,1110127)
	e3:SetCondition(c1110122.con3)
	e3:SetTarget(c1110122.tg3)
	e3:SetOperation(c1110122.op3)
	c:RegisterEffect(e3)
end
--
c1110122.named_with_Ld=1
function c1110122.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
function c1110122.IsLw(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Lw
end
--
function c1110122.xyzfilter(c)
	return c1110122.IsLd(c) 
end
function c1110122.ovfilter(c)
	return c:IsFaceup() and c:IsCode(1110002)
end
--
function c1110122.ofilter(c)
	return c1110122.IsLd(c) and c:IsType(TYPE_FIELD)
end
function c1110122.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110122.ofilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
--
function c1110122.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
--
function c1110122.filter2(c)
	return c1110122.IsLw(c) and c:IsSSetable()
end
function c1110122.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c1110122.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
--
function c1110122.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1110122.filter2,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g2=Duel.SelectMatchingCard(tp,c1110122.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			local tc=g2:GetFirst()
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
--
function c1110122.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
--
function c1110122.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
--
function c1110122.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetOperation(c1110122.op4)
	c:RegisterEffect(e4)
end
function c1110122.filter4(c)
	return c:IsCode(1110002) and c:IsAbleToHand()
end
function c1110122.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c1110122.filter4,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c1110122.filter4,tp,LOCATION_REMOVED,0,1,1,nil)
		tc=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
