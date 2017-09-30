--动摇的心境 美树沙耶加
function c11200003.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,11200003)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c11200003.tgcon)
	e1:SetTarget(c11200003.tgtg)
	e1:SetOperation(c11200003.tgop)
	c:RegisterEffect(e1)
	--lpcost replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetDescription(aux.Stringid(11200003,0))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_LPCOST_REPLACE)
	e2:SetCondition(c11200003.lrcon)
	e2:SetOperation(c11200003.lrop)
	c:RegisterEffect(e2)
end
--
function c11200003.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c11200003.tgfilter(c)
	return c:IsSetCard(0x134) and c:IsAbleToGrave()
end
function c11200003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200003.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c11200003.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11200003.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
--
function c11200003.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	local lp=Duel.GetLP(ep)
	if lp<=ev then return false end
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc:IsSetCard(0x134) and e:GetHandler():IsAbleToRemoveAsCost()
end
function c11200003.lrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end