--新春型佣兵亚瑟
function c17060815.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),7,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17060815,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17060815)
	e1:SetCondition(c17060815.spcon)
	e1:SetTarget(c17060815.sptg)
	e1:SetOperation(c17060815.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060815,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c17060815.regcon)
	e2:SetTarget(c17060815.regtg)
	e2:SetOperation(c17060815.regop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060815,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,170608151)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c17060815.descon)
	e3:SetCost(c17060815.descost)
	e3:SetTarget(c17060815.destg)
	e3:SetOperation(c17060815.desop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(17060815,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c17060815.pencon)
	e4:SetTarget(c17060815.pentg)
	e4:SetOperation(c17060815.penop)
	c:RegisterEffect(e4)
end
c17060815.pendulum_level=7
c17060815.is_named_with_Mercenary_Arthur=1
c17060815.is_named_with_Million_Arthur=1
function c17060815.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function c17060815.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060815.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c17060815.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c17060815.mfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c17060815.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c17060815.mfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(17060815,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=g:Select(tp,1,1,nil)
			if mg:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then return end
			Duel.Overlay(c,mg)
		end
	end
end
function c17060815.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c17060815.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_PENDULUM) end
end
function c17060815.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c17060815.thcon)
	e1:SetOperation(c17060815.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c17060815.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c17060815.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17060815.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c17060815.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,17060815)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17060815.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17060815.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17060815.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and 
	e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_PENDULUM) and
	e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c17060815.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c17060815.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c17060815.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c17060815.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c17060815.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetTextAttack()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
function c17060815.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17060815.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17060815.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end