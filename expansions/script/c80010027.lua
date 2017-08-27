--222 下架
function c80010027.initial_effect(c)
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80010027,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(c80010027.lpop)
	c:RegisterEffect(e1)	
end
function c80010027.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,1000)
end