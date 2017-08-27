--夏恋 恋爱小寻
function c10123004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10123004)
	e1:SetCondition(c10123004.spcon)
	c:RegisterEffect(e1) 
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10123004,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10123004.drcon)
	e2:SetTarget(c10123004.drtg)
	e2:SetOperation(c10123004.drop)
	c:RegisterEffect(e2)	  
end
function c10123004.spfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER) and not c:IsCode(10123004)
end
function c10123004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c10123004.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10123004.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c10123004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10123004.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	--if ct==0 then return end
	--local dc=Duel.GetOperatedGroup():GetFirst()
	--Duel.ConfirmCards(1-tp,dc)
	--if dc:IsSetCard(0x5334) and dc:IsType(TYPE_MONSTER) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(10123004,1)) then
		--Duel.Draw(tp,1,REASON_EFFECT)
	--end
	--Duel.ShuffleHand(tp)
end