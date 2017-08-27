--大地女神 金发的西芙
function c10119006.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,2)
	c:EnableReviveLimit()  
	--chooseeffect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10119006,2))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10119006)
	e1:SetCost(c10119006.cost)
	e1:SetTarget(c10119006.target)
	e1:SetOperation(c10119006.operation)
	c:RegisterEffect(e1)
	e1:SetLabelObject(nil)
end

function c10119006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:SetLabelObject(Duel.GetOperatedGroup():GetFirst())
end

function c10119006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b1=Duel.IsExistingTarget(c10119006.mafilter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler())
	local b2=Duel.IsExistingTarget(c10119006.tdfilter,tp,LOCATION_GRAVE,0,2,e:GetLabelObject())
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(10119006,0),aux.Stringid(10119006,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(10119006,0))
	else op=Duel.SelectOption(tp,aux.Stringid(10119006,1))+1 end
	e:SetLabel(op)
	e:SetLabelObject(nil)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c10119006.mafilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,c10119006.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	end
end

function c10119006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	if e:GetLabel()==0 and tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(e:GetHandler(),tg)
	else
	 if tg:GetCount()~=2 then return end
	 if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=2 then return end
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		 local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		 if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		 end
	end
end

function c10119006.tdfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToDeck()
end
 
function c10119006.mafilter(c,xyzc)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(xyzc)
end
