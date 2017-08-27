--暗黑天使 衣卒尔
function c10121008.initial_effect(c)
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(RACE_FAIRY)
	c:RegisterEffect(e1)   
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10121008,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c10121008.destg)
	e2:SetOperation(c10121008.desop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetOperation(c10121008.op)
	c:RegisterEffect(e4) 
end

function c10121008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function c10121008.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.Destroy(c,REASON_EFFECT)
	end
end
function c10121008.op(e,tp,eg,ep,ev,re,r,rp)
	   --tohand
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PHASE+PHASE_END)
	   e1:SetCountLimit(1)
	   e1:SetOperation(c10121008.thop)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e1,tp)
end
function c10121008.thfilter(c)
	return c:IsRace(RACE_FIEND+RACE_FAIRY) and c:IsAbleToHand()
end

function c10121008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10121008)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10121008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end