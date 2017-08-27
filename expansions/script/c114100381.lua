--★聖槍十三騎士団黒円卓X 紅蜘蛛
function c114100381.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c114100381.indval)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c114100381.efilter)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,114100381)
	e3:SetCondition(c114100381.thcon1)
	e3:SetTarget(c114100381.thtg)
	e3:SetOperation(c114100381.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCondition(c114100381.thcon2)
	c:RegisterEffect(e4)
end
function c114100381.indval(e,c)
	return c:IsLevelBelow(3) or c:IsRankBelow(3)
end
function c114100381.efilter(e,re)
	return ( e:GetOwner():IsLevelBelow(3) or e:GetOwner():IsRankBelow(3) ) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--to hand
function c114100381.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():GetPreviousControler()==tp
		and e:GetHandler():IsPreviousLocation(0x0e) --LOCATION_HAND+LOCATION_ONFIELD
end
function c114100381.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c114100381.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x988)
end
function c114100381.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114100381.thop(e,tp,eg,ep,ev,re,r,rp)
	local chg1=Duel.GetMatchingGroup(c114100381.filter,tp,LOCATION_DECK,0,nil)
	local chg2=Duel.GetMatchingGroup(c114100381.filter,tp,0,LOCATION_DECK,nil)
	local g1
	local g2
	local tc1
	local tc2
	if chg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(114100381,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g1=Duel.SelectMatchingCard(tp,c114100381.filter,tp,LOCATION_DECK,0,1,1,nil)
		tc1=g1:GetFirst()
	end
	if chg2:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(114100381,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		g2=Duel.SelectMatchingCard(1-tp,c114100381.filter,tp,0,LOCATION_DECK,1,1,nil)
		tc2=g2:GetFirst()
	end
	if g1 and g2 then g1:Merge(g2) Duel.SendtoHand(g1,nil,REASON_EFFECT) end
	if g1 and not g2 then Duel.SendtoHand(g1,nil,REASON_EFFECT) end
	if not g1 and g2 then Duel.SendtoHand(g2,nil,REASON_EFFECT) end
	if tc1 then Duel.ConfirmCards(1-tp,tc1) end
	if tc2 then	Duel.ConfirmCards(tp,tc2) end
end
