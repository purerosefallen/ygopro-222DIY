--白泽球炼成器
function c22221301.initial_effect(c)
	--ritsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22221301.target)
	e1:SetOperation(c22221301.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220010,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,22221301)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c22221301.thcost)
	e2:SetTarget(c22221301.thtg)
	e2:SetOperation(c22221301.thop)
	c:RegisterEffect(e2)
end
c22221301.named_with_Shirasawa_Tama=1
function c22221301.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221301.filter(c,e,tp,m1,m2,ft)
	if not c22221301.IsShirasawaTama(c) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(c22221301.mfilterf,1,nil,tp,mg,c)
	end
end
function c22221301.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c22221301.mfilter(c)
	return c:GetLevel()>0 and c22221301.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c22221301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c22221301.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c22221301.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c22221301.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c22221301.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c22221301.filter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c22221301.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c22221301.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22221301.thfilter(c)
	return c22221301.IsShirasawaTama(c) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c22221301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and c:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c22221301.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c22221301.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c22221301.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:CompleteProcedure()
			tc=g:GetNext()
		end
	end
end