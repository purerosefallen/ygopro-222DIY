--援护火炮
function c13254111.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c13254111.lfilter),3,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254111,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c13254111.destg)
	e1:SetOperation(c13254111.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254111,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetCost(c13254111.descost2)
	e2:SetTarget(c13254111.destg2)
	e2:SetOperation(c13254111.desop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c13254111.sumlimit)
	c:RegisterEffect(e3)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c13254111.sdcon)
	c:RegisterEffect(e4)
	
end
function c13254111.lfilter(c)
	return c:IsSetCard(0x356) and c:IsReleasable()
end
function c13254111.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local sg=lg:Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return sg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c13254111.desop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	local sg=lg:Filter(Card.IsControler,nil,1-tp)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c13254111.cfilter(c,tp)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsReleasable() and c:IsControler(tp)
end
function c13254111.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local sg=lg:Filter(c13254111.cfilter,nil,tp)
	if chk==0 then return sg:GetCount()>0 end
	sg=sg:Select(tp,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c13254111.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13254111.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c13254111.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_LINK)
end
function c13254111.sdcon(e)
	return e:GetHandler():GetSequence()>=0 and e:GetHandler():GetSequence()<=4
end
