--pianzhang zongjin--
function c16063040.initial_effect(c)
	aux.AddSynchroProcedure(c,c16063040.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--kill
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(c16063040.hdcon)
	e3:SetTarget(c16063040.hdtg)
	e3:SetOperation(c16063040.hdop)
	c:RegisterEffect(e3)
	--Damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16063040,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,16063040)
	e4:SetCondition(c16063040.descon)
	e4:SetTarget(c16063040.destg)
	e4:SetOperation(c16063040.desop)
	c:RegisterEffect(e4)
end
function c16063040.tfilter(c)
	return c:IsSetCard(0x5c5)
end
function c16063040.cfilter(c,tp)
	return c:IsControler(tp)
end
function c16063040.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c16063040.cfilter,1,nil,1-tp)
end
function c16063040.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() 
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
end
function c16063040.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave (sg,REASON_EFFECT+REASON_DISCARD)
	end
end
function c16063040.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end
function c16063040.desfilter(c)
	return c:IsSetCard(0x5c5) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c16063040.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c16063040.desfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c16063040.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16063040.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		local p=tc:GetBaseAttack()
		Duel.Damage(1-tp,p,REASON_EFFECT)
	end
end