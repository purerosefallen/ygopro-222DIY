--终末降临
function c10113096.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10113096.target)
	e1:SetOperation(c10113096.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113096,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c10113096.thcost)
	e2:SetTarget(c10113096.thtg)
	e2:SetOperation(c10113096.thop)
	c:RegisterEffect(e2)	
end
c10113096.fit_monster={10113095}
function c10113096.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c10113096.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)   
	local g=Duel.SelectMatchingCard(tp,c10113096.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10113096.thfilter(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand() 
end
function c10113096.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10113096.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10113096.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10113096.cfilter(c)
   return c:IsAbleToRemoveAsCost() and c:IsCode(10113095)
end
function c10113096.ritfilter(c)
   return c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsLevelAbove(8) and c:IsType(TYPE_RITUAL)
end
function c10113096.filter(c,e,tp,m,ft)
	if not c:IsCode(10113095) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg1=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	local mg2=mg1:Filter(c10113096.ritfilter,nil)
	if ft>0 then
		return mg1:CheckWithSumGreater(Card.GetRitualLevel,12,c) or mg2:GetCount()>0
	else
		return mg1:IsExists(c10113096.mfilterf,1,nil,tp,mg1,c) or (mg2:GetCount()>0 and mg2:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE))
	end
end
function c10113096.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,12,rc)
	else return false end
end
function c10113096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c10113096.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10113096.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10113096.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft):GetFirst()
	if tc then
		local mg1=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mg2=mg1:Filter(c10113096.ritfilter,nil)
		local op,mat,b1,b2,b3,b4=0,nil,mg1:CheckWithSumGreater(Card.GetRitualLevel,12,tc),mg2:GetCount()>0,mg1:IsExists(c10113096.mfilterf,1,nil,tp,mg1,tc),(mg2:GetCount()>0 and mg2:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE))
		if ft>0 then
		   if b1 and b2 then
			  op=Duel.SelectOption(tp,aux.Stringid(10113096,1),aux.Stringid(10113096,2))
		   elseif b1 then op=0
		   else op=1
		   end
		else
		   if b3 and b4 then
		   op=Duel.SelectOption(tp,aux.Stringid(10113096,1),aux.Stringid(10113096,2))+2
		   elseif b3 then op=2
		   else op=3
		   end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		if op==0 then
			mat=mg1:SelectWithSumGreater(tp,Card.GetRitualLevel,12,tc)
		elseif op==1 then
			mat=mg2:Select(tp,1,1,nil)
		elseif op==2 then
			mat=mg1:FilterSelect(tp,c10113096.mfilterf,1,1,nil,tp,mg1,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,12,tc)
			mat:Merge(mat2)
		elseif op==3 then
			mat=mg2:FilterSelect(tp,c10113096.ritfilter,1,1,nil)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end