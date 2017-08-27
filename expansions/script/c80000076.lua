--口袋妖怪 暴蝾螈
function c80000076.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d0),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--Pos Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK+NO_FLIP_EFFECT)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e2) 
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(80000076,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c80000076.destg)
	e1:SetOperation(c80000076.desop)
	c:RegisterEffect(e1)
end
function c80000076.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c80000076.dfilter(c)
	return c:IsFaceup() and c:GetDefense()<=3000 and c:IsDestructable()
end
function c80000076.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000076.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(c80000076.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c80000076.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c80000076.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
