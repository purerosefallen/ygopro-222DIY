--冰之羽翼 元素冰灵
function c80001028.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,3,c80001028.ovfilter,aux.Stringid(80001028,0),3)
	c:EnableReviveLimit()  
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(80001028,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,80001028)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c80001028.cost)
	e1:SetTarget(c80001028.target)
	e1:SetOperation(c80001028.operation)
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80001028,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,80001029)
	e2:SetCost(c80001028.cost)
	e2:SetTarget(c80001028.sptg)
	e2:SetOperation(c80001028.spop)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e2)
	--synchro summon success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80001028,3))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c80001028.drcon)
	e3:SetOperation(c80001028.drop)
	c:RegisterEffect(e3)
end
function c80001028.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_WATER 
end
function c80001028.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,80001028)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c80001028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c80001028.ovfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and c:GetRank()==4 and Duel.GetCurrentPhase()==PHASE_MAIN2 and c:GetOverlayCount()>0
end
function c80001028.filter(c)
	return c:IsSetCard(0x2dc) or c:IsSetCard(0x771) and c:IsAbleToRemove()
end
function c80001028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80001028.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c80001028.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80001028.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetCondition(c80001028.thcon)
		e1:SetOperation(c80001028.thop)
		e1:SetLabel(0)
		tc:RegisterEffect(e1)
	end
end
function c80001028.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c80001028.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==0 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else e:SetLabel(1) end
end
function c80001028.filter3(c)
	return c:GetRank()==4 and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80001028.filter1(c,e,tp,rk)
	return not c:IsCode(80001028) and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:GetRank()==5 and c:IsAttribute(ATTRIBUTE_WATER)
end
function c80001028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c80001028.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c80001028.filter3,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80001028.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	local sg=Duel.SelectMatchingCard(tp,c80001028.filter3,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Overlay(c,Group.FromCards(sg:GetFirst()))
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80001028.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end