--普通的少女 美树沙耶加
function c11200001.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,11200001)
	e1:SetCost(c11200001.thcost)
	e1:SetTarget(c11200001.thtg)
	e1:SetOperation(c11200001.thop)
	c:RegisterEffect(e1)
	--lpcost replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetDescription(aux.Stringid(11200001,0))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_LPCOST_REPLACE)
	e2:SetCondition(c11200001.lrcon)
	e2:SetOperation(c11200001.lrop)
	c:RegisterEffect(e2)
end
--
function c11200001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11200001.filter(c)
	return c11200001.mfilter(c) and c:IsAbleToHand()
end
function c11200001.mfilter(c)
	return c:IsSetCard(0x134) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_RITUAL)
end
function c11200001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200001.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11200001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11200001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c11200001.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	local lp=Duel.GetLP(ep)
	if lp<=ev then return false end
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc:IsSetCard(0x134) and e:GetHandler():IsAbleToRemoveAsCost()
end
function c11200001.lrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end