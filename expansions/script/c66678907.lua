--忘却之海的毁灭者
function c66678907.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
	--summon without tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66678907,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(function(e,c,minc)
		if c==nil then return true end
		return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		c:RegisterEffect(e1)
	end)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local fil1,fil2=
			function(c) return c:GetOverlayCount()~=0 and c:IsType(TYPE_XYZ) end,
			function(c) return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x665) and c:IsAbleToGraveAsCost() end
		if chk==0 then return Duel.IsExistingMatchingCard(fil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(fil2,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsAbleToGraveAsCost() end
		Duel.Hint(HINT_SELECTMSG,tp,532)
		local g1=Duel.SelectMatchingCard(tp,fil1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		g1:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,fil2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		g2:AddCard(e:GetHandler())
		Duel.SendtoGrave(g2,REASON_COST)
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local fil=function(c) return c:IsFaceup() and c:IsDestructable() end
		if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and fil(chkc) end
		if chk==0 then return Duel.IsExistingTarget(fil,tp,0,LOCATION_ONFIELD,1,nil)end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,fil,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e3)
end
