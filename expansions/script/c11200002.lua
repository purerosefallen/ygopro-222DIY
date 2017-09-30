--盲目的恋情 美树沙耶加
function c11200002.initial_effect(c)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11200002)
	e1:SetCost(c11200002.cost)
	e1:SetOperation(c11200002.op)
	c:RegisterEffect(e1)
	--lpcost replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetDescription(aux.Stringid(11200002,0))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_LPCOST_REPLACE)
	e2:SetCondition(c11200002.lrcon)
	e2:SetOperation(c11200002.lrop)
	c:RegisterEffect(e2)
end
function c11200002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	 local e1=Effect.CreateEffect(e:GetHandler())
	 e1:SetType(EFFECT_TYPE_SINGLE)
	 e1:SetCode(EFFECT_PUBLIC)
	 e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	 e:GetHandler():RegisterEffect(e1)
end
function c11200002.op(e,tp,eg,ep,ev,re,r,rp)
  Duel.RegisterFlagEffect(tp,11200002,RESET_PHASE+PHASE_END,0,1)
end
function c11200002.lrcon(e,tp,eg,ep,ev,re,r,rp)
	if tp~=ep then return false end
	local lp=Duel.GetLP(ep)
	if lp<=ev then return false end
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and rc:IsSetCard(0x134) and e:GetHandler():IsAbleToRemoveAsCost()
end
function c11200002.lrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end